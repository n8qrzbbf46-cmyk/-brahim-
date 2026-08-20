# Graphics + Vector + Simulation Accelerator Chip
## Single-File ~10 Million Transistor Class Design

### Bu dosya nedir?
Tüm önceki çalışmaları tek bir profesyonel dosyada topladım ve **~10 milyon transistor** seviyesine göre büyüttüm.

**Dosya:** `graphics_vector_sim_chip_10M.v`

İçinde:
- 64 paralel MAC birimi
- 4 adet Uzay Vektör Ünitesi (Dot, Cross, Scale…)
- Gerçek Dual-Port bellek (Host + Engine okuma/yazma)
- Tiling desteği
- Non-linear fonksiyonlar
- Profesyonel FSM + performans sayaçları
- Debug / waveform sinyalleri
- Testbench (aynı dosyanın içinde)

### Transistor Tahmini
| Blok                        | Yaklaşık Transistor |
|----------------------------|---------------------|
| 64 MAC (16×16 + 48-bit acc)| 4.5M – 5.5M        |
| 4 Vector Unit              | ~0.8M              |
| 4096×16 Dual-port SRAM     | 1.5M – 2.0M        |
| Kontrol + routing + reg    | 1.5M – 2.0M        |
| **Toplam**                 | **~9M – 11M**      |

Bu tasarım, orta ölçekli bir FPGA veya küçük bir ASIC için gerçekçi bir 10 milyon transistor sınıfı hedeftir.

### Nasıl kullanılır?
Sadece bu tek `.v` dosyasını simülatöre veya sentez aracına verin.
Testbench de aynı dosyanın içindedir.
GFM-U f100 serisi veridgim sayısal chip donanım yqzılım satlıktır fiyat lisasn olarak her chip icine bu yazılım ucreti 200 dolar donanım yazılımı sildim cunku kacıran olur diye ama boyle donanım ihtiyacınız vara konusuruz 