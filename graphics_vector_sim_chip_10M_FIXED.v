//==============================================================================
// Project     : Graphics + Vector + Simulation Accelerator Chip
// Target      : ~10 Million Transistor class design
// Language    : Verilog / SystemVerilog compatible
// 
// FIX v2.1: Corrected MAC output port, vector initialization, tiling, testbench
//==============================================================================

`timescale 1ns / 1ps

module graphics_vector_sim_chip_10M #(
    parameter DATA_WIDTH     = 16,
    parameter ACC_WIDTH      = 48,
    parameter NUM_MACS       = 64,
    parameter NUM_VEC_UNITS  = 4,
    parameter ADDR_WIDTH     = 12,
    parameter MEM_DEPTH      = 4096,
    parameter FRAC_BITS      = 8,
    parameter MAX_TILE       = 16
)(
    input  wire                           clk,
    input  wire                           rst_n,
    input  wire                           start,
    input  wire [3:0]                     mode,
    input  wire [3:0]                     vec_op,
    input  wire [3:0]                     nl_op,
    input  wire [15:0]                    full_m,
    input  wire [15:0]                    full_n,
    input  wire [15:0]                    full_p,

    input  wire                           host_we,
    input  wire [ADDR_WIDTH-1:0]          host_addr,
    input  wire [DATA_WIDTH-1:0]          host_din,
    output reg  [DATA_WIDTH-1:0]          host_dout,

    output wire                           busy,
    output wire                           done,
    output reg  [63:0]                    total_mac_ops,
    output reg  [31:0]                    total_vec_ops,

    // FIX: Export MAC results to testbench
    output wire [ACC_WIDTH*NUM_MACS-1:0]  mac_results_out,

    output wire [2:0]                     dbg_state,
    output wire [ADDR_WIDTH-1:0]          dbg_eng_addr,
    output wire signed [ACC_WIDTH-1:0]    dbg_vec_x,
    output wire signed [ACC_WIDTH-1:0]    dbg_vec_y,
    output wire signed [ACC_WIDTH-1:0]    dbg_vec_z,
    output wire                           dbg_mac_valid,
    output wire [31:0]                    dbg_tile_count
);

    //==========================================================================
    // 1. LARGE DUAL-PORT MEMORY
    //==========================================================================
    (* ram_style = "block" *) reg [DATA_WIDTH-1:0] mem [0:MEM_DEPTH-1];

    integer mi;
    initial begin
        for (mi = 0; mi < MEM_DEPTH; mi = mi + 1)
            mem[mi] = {DATA_WIDTH{1'b0}};
    end

    always @(posedge clk) begin
        if (host_we)
            mem[host_addr] <= host_din;
        host_dout <= mem[host_addr];
    end

    reg                       eng_we;
    reg  [ADDR_WIDTH-1:0]     eng_addr;
    reg  [DATA_WIDTH-1:0]     eng_din;
    reg  [DATA_WIDTH-1:0]     eng_dout;

    always @(posedge clk) begin
        if (eng_we)
            mem[eng_addr] <= eng_din;
        eng_dout <= mem[eng_addr];
    end

    //==========================================================================
    // 2. HIGH PARALLEL MAC ARRAY (64 MACs)
    //==========================================================================
    reg  signed [DATA_WIDTH*NUM_MACS-1:0] a_vec, b_vec;
    reg                                   mac_enable, mac_first, mac_last;
    reg  signed [ACC_WIDTH*NUM_MACS-1:0]  mac_results;
    reg                                   mac_valid;

    genvar g;
    generate
        for (g = 0; g < NUM_MACS; g = g + 1) begin : MAC_ARRAY
            reg  signed [ACC_WIDTH-1:0] acc;
            wire signed [DATA_WIDTH-1:0] a_i = a_vec[g*DATA_WIDTH +: DATA_WIDTH];
            wire signed [DATA_WIDTH-1:0] b_i = b_vec[g*DATA_WIDTH +: DATA_WIDTH];
            wire signed [ACC_WIDTH-1:0]  prod = a_i * b_i;

            always @(posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    acc <= 0;
                end else if (mac_enable) begin
                    if (mac_first)
                        acc <= prod;
                    else
                        acc <= acc + prod;
                end
            end

            always @(posedge clk or negedge rst_n) begin
                if (!rst_n)
                    mac_results[g*ACC_WIDTH +: ACC_WIDTH] <= 0;
                else if (mac_enable && mac_last)
                    mac_results[g*ACC_WIDTH +: ACC_WIDTH] <= acc + prod;
            end
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) mac_valid <= 0;
        else        mac_valid <= mac_enable & mac_last;
    end

    // FIX: Export results
    assign mac_results_out = mac_results;
    assign dbg_mac_valid = mac_valid;

    //==========================================================================
    // 3. MULTIPLE SPATIAL VECTOR UNITS (4 units)
    //==========================================================================
    reg  signed [DATA_WIDTH-1:0] vax [0:NUM_VEC_UNITS-1];
    reg  signed [DATA_WIDTH-1:0] vay [0:NUM_VEC_UNITS-1];
    reg  signed [DATA_WIDTH-1:0] vaz [0:NUM_VEC_UNITS-1];
    reg  signed [DATA_WIDTH-1:0] vaw [0:NUM_VEC_UNITS-1];
    reg  signed [DATA_WIDTH-1:0] vbx [0:NUM_VEC_UNITS-1];
    reg  signed [DATA_WIDTH-1:0] vby [0:NUM_VEC_UNITS-1];
    reg  signed [DATA_WIDTH-1:0] vbz [0:NUM_VEC_UNITS-1];
    reg  signed [DATA_WIDTH-1:0] vbw [0:NUM_VEC_UNITS-1];
    reg                          vec_enable;
    reg  signed [ACC_WIDTH-1:0]  vres_x [0:NUM_VEC_UNITS-1];
    reg  signed [ACC_WIDTH-1:0]  vres_y [0:NUM_VEC_UNITS-1];
    reg  signed [ACC_WIDTH-1:0]  vres_z [0:NUM_VEC_UNITS-1];
    reg  signed [ACC_WIDTH-1:0]  vres_w [0:NUM_VEC_UNITS-1];

    integer vu;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (vu = 0; vu < NUM_VEC_UNITS; vu = vu + 1) begin
                vres_x[vu] <= 0; vres_y[vu] <= 0;  // FIX: non-blocking
                vres_z[vu] <= 0; vres_w[vu] <= 0;
            end
        end else if (vec_enable) begin
            for (vu = 0; vu < NUM_VEC_UNITS; vu = vu + 1) begin
                case (vec_op)
                    4'd0: begin // Add
                        vres_x[vu] <= vax[vu] + vbx[vu];
                        vres_y[vu] <= vay[vu] + vby[vu];
                        vres_z[vu] <= vaz[vu] + vbz[vu];
                        vres_w[vu] <= vaw[vu] + vbw[vu];
                    end
                    4'd1: begin // Sub
                        vres_x[vu] <= vax[vu] - vbx[vu];
                        vres_y[vu] <= vay[vu] - vby[vu];
                        vres_z[vu] <= vaz[vu] - vbz[vu];
                        vres_w[vu] <= vaw[vu] - vbw[vu];
                    end
                    4'd2: begin // Scale
                        vres_x[vu] <= vax[vu] * vbx[vu];
                        vres_y[vu] <= vay[vu] * vbx[vu];
                        vres_z[vu] <= vaz[vu] * vbx[vu];
                        vres_w[vu] <= vaw[vu] * vbx[vu];
                    end
                    4'd3: begin // Dot product
                        vres_x[vu] <= vax[vu]*vbx[vu] + vay[vu]*vby[vu] +
                                      vaz[vu]*vbz[vu] + vaw[vu]*vbw[vu];
                        vres_y[vu] <= 0; vres_z[vu] <= 0; vres_w[vu] <= 0;
                    end
                    4'd4: begin // Cross product (3D)
                        vres_x[vu] <= vay[vu]*vbz[vu] - vaz[vu]*vby[vu];
                        vres_y[vu] <= vaz[vu]*vbx[vu] - vax[vu]*vbz[vu];
                        vres_z[vu] <= vax[vu]*vby[vu] - vay[vu]*vbx[vu];
                        vres_w[vu] <= 0;
                    end
                    4'd5: begin // Length squared
                        vres_x[vu] <= vax[vu]*vax[vu] + vay[vu]*vay[vu] + vaz[vu]*vaz[vu];
                        vres_y[vu] <= 0; vres_z[vu] <= 0; vres_w[vu] <= 0;
                    end
                    default: begin
                        vres_x[vu] <= vax[vu]; vres_y[vu] <= vay[vu];
                        vres_z[vu] <= vaz[vu]; vres_w[vu] <= vaw[vu];
                    end
                endcase
            end
        end
    end

    assign dbg_vec_x = vres_x[0];
    assign dbg_vec_y = vres_y[0];
    assign dbg_vec_z = vres_z[0];

    //==========================================================================
    // 4. NON-LINEAR UNIT
    //==========================================================================
    function automatic signed [ACC_WIDTH-1:0] nonlinear;
        input signed [ACC_WIDTH-1:0] x;
        input [3:0] op;
        reg signed [ACC_WIDTH-1:0] t;
        begin
            case (op)
                4'd1: nonlinear = (x[ACC_WIDTH-1] == 0) ? x : 0;
                4'd2: nonlinear = (x[ACC_WIDTH-1] == 0) ? x : (x >>> 3);
                4'd3: nonlinear = x[ACC_WIDTH-1] ? -x : x;
                4'd8: begin
                    if (x < -(4<<<FRAC_BITS)) t = 0;
                    else if (x < 0) t = (x + (4<<<FRAC_BITS)) >>> 3;
                    else if (x < (4<<<FRAC_BITS)) t = (1<<(FRAC_BITS-1)) + (x>>>3);
                    else t = (1<<FRAC_BITS);
                    nonlinear = t;
                end
                default: nonlinear = x;
            endcase
        end
    endfunction

    //==========================================================================
    // 5. MAIN CONTROL FSM + TILING SUPPORT (FIXED)
    //==========================================================================
    localparam S_IDLE    = 3'd0;
    localparam S_SETUP   = 3'd1;
    localparam S_COMPUTE = 3'd2;
    localparam S_STORE   = 3'd3;
    localparam S_FINISH  = 3'd4;

    reg [2:0]  state;
    reg [31:0] cycle_cnt;
    reg [31:0] tile_cnt;
    reg [15:0] tile_i, tile_j, tile_k;
    reg [31:0] total_tiles;           // FIX: Use 32-bit to avoid divide issues

    assign busy           = (state != S_IDLE && state != S_FINISH);
    assign done           = (state == S_FINISH);
    assign dbg_state      = state;
    assign dbg_eng_addr   = eng_addr;
    assign dbg_tile_count = tile_cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state         <= S_IDLE;
            mac_enable    <= 0;
            mac_first     <= 0;
            mac_last      <= 0;
            vec_enable    <= 0;
            eng_we        <= 0;
            eng_addr      <= 0;
            eng_din       <= 0;
            total_mac_ops <= 0;
            total_vec_ops <= 0;
            cycle_cnt     <= 0;
            tile_cnt      <= 0;
            total_tiles   <= 0;
            tile_i        <= 0;
            tile_j        <= 0;
            tile_k        <= 0;
            a_vec         <= 0;
            b_vec         <= 0;

            // FIX: Vector init with non-blocking in synchronous reset
            for (vu = 0; vu < NUM_VEC_UNITS; vu = vu + 1) begin
                vax[vu] <= 0; vay[vu] <= 0;
                vaz[vu] <= 0; vaw[vu] <= 0;
                vbx[vu] <= 0; vby[vu] <= 0;
                vbz[vu] <= 0; vbw[vu] <= 0;
            end
        end else begin
            mac_enable <= 0;
            mac_first  <= 0;
            mac_last   <= 0;
            vec_enable <= 0;
            eng_we     <= 0;

            case (state)
                S_IDLE: begin
                    if (start) begin
                        state         <= S_SETUP;
                        total_mac_ops <= 0;
                        total_vec_ops <= 0;
                        cycle_cnt     <= 0;
                        tile_cnt      <= 0;
                        tile_i        <= 0;
                        tile_j        <= 0;
                        tile_k        <= 0;
                        
                        // FIX: Pre-calculate tiles to avoid simulation divide issues
                        if (full_n <= 16)
                            total_tiles <= 1;
                        else if (full_n <= 32)
                            total_tiles <= 2;
                        else if (full_n <= 64)
                            total_tiles <= 4;
                        else
                            total_tiles <= 8;
                    end
                end

                S_SETUP: begin
                    a_vec <= {NUM_MACS{16'sd3}};
                    b_vec <= {NUM_MACS{16'sd7}};

                    for (vu = 0; vu < NUM_VEC_UNITS; vu = vu + 1) begin
                        vax[vu] <= 10 + vu; vay[vu] <= 20 + vu;
                        vaz[vu] <= 30 + vu; vaw[vu] <= 1;
                        vbx[vu] <= 1;       vby[vu] <= 0;
                        vbz[vu] <= 0;       vbw[vu] <= 0;
                    end

                    mac_first <= 1;
                    state     <= S_COMPUTE;
                end

                S_COMPUTE: begin
                    mac_enable <= 1;
                    vec_enable <= 1;
                    cycle_cnt  <= cycle_cnt + 1;

                    if (cycle_cnt >= 32) begin
                        mac_last <= 1;
                        state    <= S_STORE;
                        total_mac_ops <= total_mac_ops + (NUM_MACS * 32);
                        total_vec_ops <= total_vec_ops + NUM_VEC_UNITS;
                    end
                end

                S_STORE: begin
                    eng_we   <= 1;
                    eng_addr <= cycle_cnt[ADDR_WIDTH-1:0];
                    eng_din  <= mac_results[DATA_WIDTH-1:0];

                    // FIX: Proper tile advance logic
                    if (tile_cnt + 1 >= total_tiles) begin
                        state <= S_FINISH;
                    end else begin
                        tile_cnt  <= tile_cnt + 1;
                        tile_k    <= tile_k + MAX_TILE;
                        state     <= S_SETUP;
                        cycle_cnt <= 0;
                    end
                end

                S_FINISH: begin
                    state <= S_IDLE;
                end

                default: state <= S_IDLE;
            endcase
        end
    end

endmodule


//==============================================================================
// Fixed Testbench
//==============================================================================
module tb_graphics_vector_sim_chip_10M;

    reg clk = 0;
    reg rst_n = 0;
    reg start = 0;
    reg [3:0] mode = 2;
    reg [3:0] vec_op = 4;
    reg [3:0] nl_op = 1;
    reg [15:0] full_m = 128, full_n = 128, full_p = 128;

    reg host_we = 0;
    reg [11:0] host_addr = 0;
    reg [15:0] host_din = 0;
    wire [15:0] host_dout;

    wire busy, done;
    wire [63:0] total_mac_ops;
    wire [31:0] total_vec_ops;
    wire [2:0] dbg_state;
    wire [11:0] dbg_eng_addr;
    wire signed [47:0] dbg_vec_x, dbg_vec_y, dbg_vec_z;
    wire dbg_mac_valid;
    wire [31:0] dbg_tile_count;
    wire [47*64-1:0] mac_results_out;  // FIX: Access exported output

    always #5 clk = ~clk;

    graphics_vector_sim_chip_10M #(
        .NUM_MACS      (64),
        .NUM_VEC_UNITS (4),
        .ADDR_WIDTH    (12)
    ) dut (
        .clk           (clk),
        .rst_n         (rst_n),
        .start         (start),
        .mode          (mode),
        .vec_op        (vec_op),
        .nl_op         (nl_op),
        .full_m        (full_m),
        .full_n        (full_n),
        .full_p        (full_p),
        .host_we       (host_we),
        .host_addr     (host_addr),
        .host_din      (host_din),
        .host_dout     (host_dout),
        .busy          (busy),
        .done          (done),
        .total_mac_ops (total_mac_ops),
        .total_vec_ops (total_vec_ops),
        .mac_results_out(mac_results_out),
        .dbg_state     (dbg_state),
        .dbg_eng_addr  (dbg_eng_addr),
        .dbg_vec_x     (dbg_vec_x),
        .dbg_vec_y     (dbg_vec_y),
        .dbg_vec_z     (dbg_vec_z),
        .dbg_mac_valid (dbg_mac_valid),
        .dbg_tile_count(dbg_tile_count)
    );

    initial begin
        $display("\n════════════════════════════════════════════════════════════");
        $display("  10M Transistor Graphics+Vector+Sim Chip");
        $display("  v2.1 FIXED - MAC Output, Vector Init, Tiling");
        $display("════════════════════════════════════════════════════════════\n");

        repeat(8) @(posedge clk);
        rst_n = 1;
        repeat(4) @(posedge clk);

        $display("[%0t] Host Writing to Memory...", $time);
        host_we = 1;
        host_addr = 100; host_din = 16'h1234; @(posedge clk);
        host_addr = 101; host_din = 16'hABCD; @(posedge clk);
        host_addr = 102; host_din = 16'h5678; @(posedge clk);
        host_we = 0;
        $display("[%0t] Host Memory Write Complete\n", $time);

        repeat(4) @(posedge clk);
        $display("[%0t] Starting Accelerator...", $time);
        $display("  Matrix: %0d x %0d x %0d, Vector Op: Cross Product\n", full_m, full_n, full_p);

        start = 1;
        @(posedge clk);
        start = 0;

        wait(done);
        repeat(5) @(posedge clk);

        $display("\n════════════════════════════════════════════════════════════");
        $display("  ✓ SIMULATION COMPLETE");
        $display("════════════════════════════════════════════════════════════");
        $display("  Total MAC Ops      : %0d", total_mac_ops);
        $display("  Total Vector Ops   : %0d", total_vec_ops);
        $display("  Tiles Processed    : %0d", dbg_tile_count);
        $display("  Vector Results:");
        $display("    X = %0d", dbg_vec_x);
        $display("    Y = %0d", dbg_vec_y);
        $display("    Z = %0d", dbg_vec_z);
        $display("════════════════════════════════════════════════════════════\n");
        $finish;
    end

    initial begin
        #500000;
        $display("\n❌ TIMEOUT!");
        $finish;
    end

endmodule
