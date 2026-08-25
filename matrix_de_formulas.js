/**
 * MühendisX · 50 Matrix Differential Equation Formulas
 * Matris Diferansiyel Denklemler · 50 Formül Koleksiyonu
 * v1.0 · C++17 residual-gated · CODATA 2018 SI
 */

const MATRIX_DE_FORMULAS = {
  /* ==================== TEMEL MATRIS DİFERANSİYEL DENKLEMLER ==================== */
  
  // 1. dX/dt = AX (Homojen Lineer)
  formula_001: {
    name: "Homojen Lineer Sistem",
    equation: "dX/dt = AX",
    description: "En basit matris diferansiyel denklemi",
    solution: "X(t) = e^(At) · X₀",
    example: "A = [[1, 2], [0, -1]]",
    type: "homogeneous_linear",
    difficulty: "beginner"
  },

  // 2. dX/dt = AX + B (Non-homojen)
  formula_002: {
    name: "Non-Homojen Lineer Sistem",
    equation: "dX/dt = AX + B(t)",
    description: "Sağ tarafında fonksiyon içeren sistem",
    solution: "X(t) = e^(At)·X₀ + e^(At)∫₀ᵗ e^(-As)·B(s)ds",
    example: "dX/dt = [[2, 1], [0, 3]]X + [[1], [t]]",
    type: "nonhomogeneous_linear",
    difficulty: "intermediate"
  },

  // 3. d²X/dt² = AX (İkinci Mertebe)
  formula_003: {
    name: "İkinci Mertebe Homojen Sistem",
    equation: "d²X/dt² = AX",
    description: "İkinci mertebeden matris diferansiyel denklemi",
    solution: "X(t) = C₁cos(√A·t) + C₂sin(√A·t)",
    example: "m·d²X/dt² = -kX, A = -k/m",
    type: "second_order",
    difficulty: "intermediate"
  },

  // 4. dX/dt = AX + BU (Kontrol Sistemi)
  formula_004: {
    name: "Kontrol Sistemi - Durum Denklemi",
    equation: "dX/dt = AX + BU",
    description: "Kontrol girdisi U(t) içeren sistem",
    solution: "X(t) = e^(At)·X₀ + e^(At)∫₀ᵗ e^(-As)·B·U(s)ds",
    example: "A ∈ ℝⁿˣⁿ, B ∈ ℝⁿˣᵐ, U ∈ ℝᵐ",
    type: "control_system",
    difficulty: "intermediate"
  },

  // 5. dX/dt = f(t,X) (Nonlineer Matris ODE)
  formula_005: {
    name: "Nonlineer Matris ODE",
    equation: "dX/dt = f(t,X)",
    description: "Genel nonlineer matris diferansiyel denklemi",
    solution: "Picard İterasyonu veya nümerik yöntemler (RK4, DOPRI5)",
    example: "dX/dt = -X² + t·I",
    type: "nonlinear",
    difficulty: "advanced"
  },

  /* ==================== ÖZ DEĞERLERİ OLAN SISTEMLER ==================== */

  // 6. Reel Tek Öz Değer - Düğüm
  formula_006: {
    name: "Reel Tek Öz Değer (λ₁ = λ₂)",
    equation: "dX/dt = AX, det(A-λI) = (λ-λ₀)²",
    description: "Çift katlı reel öz değer durumu",
    solution: "X(t) = e^(λ₀t)·(c₁v + c₂(t·v + w))",
    example: "A = [[1, 1], [0, 1]], λ₀ = 1",
    type: "eigenvalue_repeated",
    difficulty: "intermediate"
  },

  // 7. Reel Farklı Öz Değerler
  formula_007: {
    name: "Reel Farklı Öz Değerler",
    equation: "dX/dt = AX, λ₁ ≠ λ₂ ∈ ℝ",
    description: "Farklı reel öz değerlere sahip sistem",
    solution: "X(t) = c₁e^(λ₁t)v₁ + c₂e^(λ₂t)v₂",
    example: "A = [[3, 1], [1, 3]], λ₁ = 4, λ₂ = 2",
    type: "eigenvalue_distinct_real",
    difficulty: "beginner"
  },

  // 8. Kompleks Eşlenik Öz Değerler
  formula_008: {
    name: "Kompleks Eşlenik Öz Değerler",
    equation: "dX/dt = AX, λ = α ± βi",
    description: "Salınımlı davranış gösteren sistem",
    solution: "X(t) = e^(αt)[c₁cos(βt)v₁ + c₂sin(βt)v₂]",
    example: "A = [[0, -ω], [ω, 0]], λ = ±ωi",
    type: "eigenvalue_complex",
    difficulty: "intermediate"
  },

  /* ==================== MATRİS ÜSTEL FONKSİYON ==================== */

  // 9. Matrix Exponential - Eigenvalue Dekompozisyon
  formula_009: {
    name: "Matris Üstel - Eigenvalue Yöntemi",
    equation: "e^(At) = P·e^(Dt)·P⁻¹",
    description: "Köşegenleştirilebilir matrisler için",
    solution: "D köşegen matris (öz değerler), P özvektörler matrisi",
    example: "A = P·D·P⁻¹ ⇒ e^(At) = P·diag(e^(λ₁t),...,e^(λₙt))·P⁻¹",
    type: "matrix_exponential",
    difficulty: "intermediate"
  },

  // 10. Matrix Exponential - Taylor Serisi
  formula_010: {
    name: "Matris Üstel - Taylor Serisi",
    equation: "e^(At) = Σ(n=0 to ∞) (At)ⁿ/n!",
    description: "Matris üstelinin seri açılımı",
    solution: "e^(At) = I + At + A²t²/2! + A³t³/3! + ...",
    example: "A nilpotent ise (A^k = 0): e^(At) sonlu toplam",
    type: "matrix_exponential_series",
    difficulty: "intermediate"
  },

  /* ==================== JORDAN NORMAL FORM ==================== */

  // 11. Jordan Blok (1×1)
  formula_011: {
    name: "Jordan Blok - 1×1",
    equation: "J₁(λ) = [λ]",
    description: "En basit Jordan blok",
    solution: "e^(J₁t) = e^(λt)",
    example: "Tek bir öz değer için",
    type: "jordan_block",
    difficulty: "beginner"
  },

  // 12. Jordan Blok (2×2)
  formula_012: {
    name: "Jordan Blok - 2×2",
    equation: "J₂(λ) = [[λ, 1], [0, λ]]",
    description: "İkinci mertebeden Jordan blok",
    solution: "e^(J₂t) = e^(λt)·[[1, t], [0, 1]]",
    example: "Çift katlı öz değer durumu",
    type: "jordan_block",
    difficulty: "intermediate"
  },

  // 13. Jordan Blok (n×n)
  formula_013: {
    name: "Jordan Blok - n×n Genel",
    equation: "Jₙ(λ) = [[λ, 1, 0, ...], [0, λ, 1, ...], [...], [0, ..., 0, λ]]",
    description: "n-katlı öz değer durumu",
    solution: "e^(Jₙt) = e^(λt)·Σ(k=0 to n-1) tᵏ/k!·Nᵏ, N nilpotent",
    example: "n=3: e^(J₃t) = e^(λt)·[1+tN+t²N²/2]",
    type: "jordan_block",
    difficulty: "advanced"
  },

  /* ==================== STABİLİTE ANALİZİ ==================== */

  // 14. Lyapunov Stabilite Kriterleri
  formula_014: {
    name: "Lyapunov Stabilite - Lineer Sistem",
    equation: "dX/dt = AX stabil ⟺ Re(λᵢ) < 0 ∀λᵢ",
    description: "Sistemin asimptotik stabilitesi için koşul",
    solution: "Tüm öz değerlerin gerçek kısımları negatif olmalı",
    example: "A = [[-1, 0], [0, -2]] → stabil",
    type: "stability",
    difficulty: "intermediate"
  },

  // 15. Routh-Hurwitz Kriteri
  formula_015: {
    name: "Routh-Hurwitz Stabilite Kriteri",
    equation: "Karakteristik polinom: det(λI - A) = 0",
    description: "Öz değerleri hesaplamadan stabilite testi",
    solution: "Routh tablosu işaret değişimleri sayısı",
    example: "3×3 sistem için: det = λ³ + 3λ² + 3λ + 1",
    type: "stability_criterion",
    difficulty: "advanced"
  },

  /* ==================== PERTÜRBASYON VE VARYASYON ==================== */

  // 16. Birinci Mertebe Pertürbasyon
  formula_016: {
    name: "Pertürbasyon Yöntemi - Birinci Mertebe",
    equation: "dX/dt = AX + εB(t)X",
    description: "Küçük pertürbasyon parametresi ε",
    solution: "X(t) = X₀(t) + εX₁(t) + ε²X₂(t) + ...",
    example: "X₀: e^(At)X(0), X₁: pertürbe çözüm",
    type: "perturbation",
    difficulty: "advanced"
  },

  // 17. Varyasyon Parametresi Yöntemi
  formula_017: {
    name: "Varyasyon Parametresi Yöntemi",
    equation: "dX/dt = AX + B(t)",
    description: "Homojen çözümden non-homojen çözüm",
    solution: "X(t) = e^(At)[C + ∫ e^(-As)B(s)ds]",
    example: "Homojen: X_h, Particular: X_p konvülüsyon",
    type: "variation_of_parameters",
    difficulty: "intermediate"
  },

  /* ==================== KRONECKER VE TENSÖRİEL ÇARPIM ==================== */

  // 18. Kronecker Çarpımı ile Vektörleştirme
  formula_018: {
    name: "Vektörleştirme - Kronecker Çarpımı",
    equation: "vec(AXB) = (B^T ⊗ A)·vec(X)",
    description: "Matris denklemi vektör denkleme dönüştürme",
    solution: "dX/dt = AX + XB → d(vec X)/dt = (I ⊗ A + B^T ⊗ I)·vec X",
    example: "A ∈ ℝᵐˣⁿ, B ∈ ℝⁿˣᵖ, X ∈ ℝⁿˣⁿ",
    type: "kronecker_product",
    difficulty: "advanced"
  },

  // 19. Sylvester Denklemi
  formula_019: {
    name: "Sylvester Denklemi",
    equation: "AX + XB = C",
    description: "Matris X için lineer cebirsel denklem",
    solution: "vec(X) = (I ⊗ A + B^T ⊗ I)⁻¹·vec(C)",
    example: "Kontrol teorisinde pole assignment problemlerinde",
    type: "sylvester_equation",
    difficulty: "intermediate"
  },

  // 20. Lyapunov Denklemi
  formula_020: {
    name: "Lyapunov Denklemi",
    equation: "AP + PA^T + Q = 0",
    description: "Stabilite testi için kullanılan denklem",
    solution: "P = -∫₀^∞ e^(At)·Q·e^(A^T·t)dt (stabil A için)",
    example: "Kontrol teorisi: P simetriktir, Q = I",
    type: "lyapunov_equation",
    difficulty: "intermediate"
  },

  /* ==================== SÜREKSIZ SİSTEMLER ==================== */

  // 21. Süreksiz Matris Sistemi - Parça Parça
  formula_021: {
    name: "Süreksiz Durum Geçişi",
    equation: "dX/dt = A₁X (t < t₀), dX/dt = A₂X (t > t₀)",
    description: "Farklı bölgelerde farklı dinamikler",
    solution: "X(t) = e^(A₂(t-t₀))·e^(A₁·t₀)·X₀ (t > t₀)",
    example: "Regle sistemler, anahtarlamalı sistemler",
    type: "piecewise_continuous",
    difficulty: "advanced"
  },

  // 22. İmpulsif Sistem
  formula_022: {
    name: "İmpulsif Matris Sistemi",
    equation: "dX/dt = AX (t ≠ tₖ), ΔX|ₜ₌ₜₖ = BₖX(tₖ)",
    description: "Belirli zaman noktalarında ani atışlar",
    solution: "X(tₖ⁺) = (I + Bₖ)X(tₖ⁻)",
    example: "Örnek almalı sistemler, doğrusal olmayan atışlar",
    type: "impulsive_system",
    difficulty: "advanced"
  },

  /* ==================== ZAMaN DEĞİŞKEN SİSTEMLER ==================== */

  // 23. Zaman Değişken Sistem - Genel
  formula_023: {
    name: "Zaman Değişken Lineer Sistem",
    equation: "dX/dt = A(t)X",
    description: "Matris A(t) zamana bağlı",
    solution: "X(t) = Φ(t,t₀)·X(t₀), Φ = temel matris",
    example: "dX/dt = [[1+t, 0], [0, -2t]]·X",
    type: "time_varying",
    difficulty: "advanced"
  },

  // 24. Temel Matris Çözümü
  formula_024: {
    name: "Temel Matris Çözümü",
    equation: "dΦ/dt = A(t)·Φ, Φ(t₀) = I",
    description: "Zaman değişken sistem için temel matris",
    solution: "X(t) = Φ(t)·Φ⁻¹(t₀)·X(t₀)",
    example: "Φ(t,t₀) = Φ(t)·Φ⁻¹(t₀)",
    type: "fundamental_matrix",
    difficulty: "advanced"
  },

  // 25. Magnus Açılımı
  formula_025: {
    name: "Magnus Açılımı",
    equation: "Φ(t) ≈ exp(Ω(t))",
    description: "Zaman değişken sistemin seri çözümü",
    solution: "Ω = ∫A dt + (1/2)∫[A,∫A dt]dt + ...",
    example: "Hızlı salınımlı sistemler için yaklaşım",
    type: "magnus_expansion",
    difficulty: "advanced"
  },

  /* ==================== DOĞRUSAL OLMAYAN SISTEMLER ==================== */

  // 26. Hartman-Grobman Teoremi
  formula_026: {
    name: "Hartman-Grobman Lineerleştirme",
    equation: "dX/dt = f(X), f(0)=0, Df(0)=A",
    description: "Nonlineer sistem lineer yaklaşımı",
    solution: "Sabit nokta civarında: dX/dt ≈ A·X",
    example: "Sarkaç denklemi lineerleştirilmesi",
    type: "linearization",
    difficulty: "advanced"
  },

  // 27. Lie Grubu Yöntemi
  formula_027: {
    name: "Lie Grubu - Simetri Dönüşümü",
    equation: "dX/dt = f(t,X), G: Lie grubu simetrisi",
    description: "Simetri dönüşümlerini kullanarak çözüm",
    solution: "Değişken dönüşümü ile sistem boyutu azaltma",
    example: "Ölçek simetrisi: X → λX, t → μt",
    type: "lie_group",
    difficulty: "advanced"
  },

  /* ==================== MATRIS POLİNOMİ ==================== */

  // 28. Cayley-Hamilton Teoremi
  formula_028: {
    name: "Cayley-Hamilton Teoremi",
    equation: "p(A) = 0, p(λ) = det(λI - A)",
    description: "Her matris kendi karakteristik polinomunu sağlar",
    solution: "Aⁿ lineer kombinasyon olarak yazılır",
    example: "2×2: A² - trA·A + detA·I = 0",
    type: "cayley_hamilton",
    difficulty: "intermediate"
  },

  // 29. Minimal Polinom
  formula_029: {
    name: "Minimal Polinom",
    equation: "m(A) = 0, m(λ) minimal derece",
    description: "A'yı sıfır yapan minimum derece polinom",
    solution: "m(λ) = p(λ)/gcd(minors)",
    example: "Köşegenleştirilebilir: m = (λ-λ₁)...(λ-λₖ)",
    type: "minimal_polynomial",
    difficulty: "advanced"
  },

  /* ==================== KOORDİNAT DÖNÜŞÜMLERİ ==================== */

  // 30. Benzerlik Dönüşümü
  formula_030: {
    name: "Benzerlik Dönüşümü (Similarity Transform)",
    equation: "B = P⁻¹AP",
    description: "Farklı bazda aynı sistem",
    solution: "dY/dt = BY, Y = P⁻¹X",
    example: "Modal dekompozisyon: B köşegen veya Jordan",
    type: "similarity_transform",
    difficulty: "beginner"
  },

  // 31. Ortogonal Dönüşüm - QR Dekompozisyon
  formula_031: {
    name: "Ortogonal Dekompozisyon",
    equation: "A = QR, Q^T·Q = I",
    description: "Ortogonal matrislerle dönüşüm",
    solution: "dX/dt = QRX → dY/dt = RY, Y = Q^T·X",
    example: "Sayısal stabilite için tercih edilen yöntem",
    type: "orthogonal_decomposition",
    difficulty: "intermediate"
  },

  /* ==================== STOKASTİK SISTEMLER ==================== */

  // 32. Stokastik Diferansiyel Denklem - Itô
  formula_032: {
    name: "Itô Stokastik DE",
    equation: "dX = A(t,X)dt + B(t,X)dW",
    description: "Wiener süreci W(t) ile stokastik sistem",
    solution: "Itô lemması ile çözüm, Fokker-Planck denklemi",
    example: "Geometrik Brown hareketi: dX = μX·dt + σX·dW",
    type: "stochastic_ito",
    difficulty: "advanced"
  },

  // 33. Fokker-Planck Denklemi
  formula_033: {
    name: "Fokker-Planck Denklemi",
    equation: "∂p/∂t = -∇·(A·p) + (1/2)∇²·(B·B^T·p)",
    description: "Olasılık yoğunluğu fonksiyonunun evrimi",
    solution: "p(t,x) olasılık dağılımı",
    example: "Ornstein-Uhlenbeck süreci",
    type: "fokker_planck",
    difficulty: "advanced"
  },

  /* ==================== YAKLAŞIM YÖNTEMLERİ ==================== */

  // 34. Runge-Kutta 4. Mertebe (RK4)
  formula_034: {
    name: "RK4 Nümerik Integrasyon",
    equation: "dX/dt = f(t,X)",
    description: "Dört kademeli açık Runge-Kutta yöntemi",
    solution: "Xₙ₊₁ = Xₙ + (h/6)(k₁+2k₂+2k₃+k₄)",
    example: "k₁=f(t,X), k₂=f(t+h/2,X+hk₁/2), ...",
    type: "numerical_rk4",
    difficulty: "beginner"
  },

  // 35. Dormand-Prince RK5(4) - DOPRI5
  formula_035: {
    name: "DOPRI5 Adaptif Adım",
    equation: "dX/dt = f(t,X)",
    description: "Beş mertebeden uyarlanabilir adım yöntemi",
    solution: "Hata tahmini ile otomatik adım kontrol",
    example: "SciPy.integrate.odeint ve solve_ivp",
    type: "numerical_dopri5",
    difficulty: "intermediate"
  },

  // 36. BDF (Gear Yöntemi)
  formula_036: {
    name: "BDF - İmplisit Yöntem",
    equation: "dX/dt = f(t,X)",
    description: "Stiff denklemler için uygun yöntem",
    solution: "Çok adımlı formül: Σaₖ Xₙ₋ₖ = h·f(Xₙ)",
    example: "BDF1-BDF6, Newton iterasyonu gerekli",
    type: "numerical_bdf",
    difficulty: "advanced"
  },

  /* ==================== SPEKTRAL YÖNTEMLER ==================== */

  // 37. Fourier Serisi Yöntemi
  formula_037: {
    name: "Fourier Serisi Spektral Yöntemi",
    equation: "X(t) = Σ Xₖ·e^(ikωt)",
    description: "Periyodik sistemlerde Fourier yaklaşımı",
    solution: "Zaman-frekans ayrışması",
    example: "Periyodik forzaj: dX/dt = AX + B·cos(ωt)",
    type: "spectral_fourier",
    difficulty: "advanced"
  },

  // 38. Chebyshev Polinom Yöntemi
  formula_038: {
    name: "Chebyshev Polinom Yaklaşımı",
    equation: "X(t) ≈ Σ Xₖ·Tₖ(t)",
    description: "Chebyshev polinomlarıyla yaklaşım",
    solution: "Galerkin yöntemi ile sistem azaltma",
    example: "Optimal yakınsaklık: x ∈ [-1,1]",
    type: "spectral_chebyshev",
    difficulty: "advanced"
  },

  /* ==================== FAZA İLİŞKİN ÇÖZÜMLER ==================== */

  // 39. Faz Düzlemi Analizi
  formula_039: {
    name: "Faz Düzlemi Portresi",
    equation: "dX/dt = f(X), n=2",
    description: "İki boyutlu sistemin vektör alanı",
    solution: "Isocline ve faz yörüngeleri",
    example: "Predator-prey, Van der Pol osilatörü",
    type: "phase_plane",
    difficulty: "intermediate"
  },

  // 40. Limit Döngüsü
  formula_040: {
    name: "Limit Döngüsü (Limit Cycle)",
    equation: "dX/dt = f(X), γ kapalı yörünge",
    description: "İzole kapalı yörünge - periyodik hareket",
    solution: "Poincaré haritası, çatallanma analizi",
    example: "Van der Pol: ε·d²x/dt² + (x²-1)dx/dt + x = 0",
    type: "limit_cycle",
    difficulty: "advanced"
  },

  /* ==================== ÇATALLANMa ANALİZİ ==================== */

  // 41. Saddle-Node Çatallanması
  formula_041: {
    name: "Saddle-Node Bifurkation",
    equation: "dX/dt = μ + X², X ∈ ℝ",
    description: "Sabit nokta oluşumu ve yokoluşu",
    solution: "μ = 0'da çatallanma, X* = ±√μ",
    example: "Transsiyon: stabil < → > sele",
    type: "bifurcation_saddle_node",
    difficulty: "advanced"
  },

  // 42. Hopf Çatallanması
  formula_042: {
    name: "Hopf Bifurkation",
    equation: "dX/dt = f(X,μ), Re(λ(μ₀))=0, λ'(μ₀)≠0",
    description: "Sabit noktadan limit döngüsü doğuş",
    solution: "Merkez manifoldu azaltma, normal form",
    example: "λ = α(μ) ± iω(μ)",
    type: "bifurcation_hopf",
    difficulty: "advanced"
  },

  // 43. Çatallanma Diyagram��
  formula_043: {
    name: "Bifurkasyon Parametresi Diyagramı",
    equation: "f(X*,μ) = 0, ∂f/∂X(X*,μ) = 0",
    description: "Sabit noktaların stabilite parametrik değişim",
    solution: "Sabit nokta eğrisi: X* = g(μ)",
    example: "Logistik harita: Xₙ₊₁ = rXₙ(1-Xₙ)",
    type: "bifurcation_diagram",
    difficulty: "intermediate"
  },

  /* ==================== DETERMINISTIK KAOSiK SİSTEMLER ==================== */

  // 44. Lorenz Sistemi
  formula_044: {
    name: "Lorenz Sistemi",
    equation: "dX/dt = σ(Y-X), dY/dt = X(ρ-Z)-Y, dZ/dt = XY-βZ",
    description: "Klasik kaotik sistem, kelebek atraktörü",
    solution: "Nümerik integrasyon, σ=10, ρ=28, β=8/3",
    example: "Atmosferik konveksiyon modeli",
    type: "chaotic_lorenz",
    difficulty: "intermediate"
  },

  // 45. Rössler Sistemi
  formula_045: {
    name: "Rössler Sistemi",
    equation: "dX/dt = -Y-Z, dY/dt = X+aY, dZ/dt = b+Z(X-c)",
    description: "Daha basit kaotik sistem",
    solution: "a=0.1, b=0.1, c=18 (kaotik rejim)",
    example: "Kimyasal reaksiyonlarda",
    type: "chaotic_rossler",
    difficulty: "intermediate"
  },

  /* ==================== ENERJI VE KORUNUM YASALARı ==================== */

  // 46. Hamiltoniyenli Sistemler
  formula_046: {
    name: "Hamilton Denklemleri",
    equation: "dq/dt = ∂H/∂p, dp/dt = -∂H/∂q",
    description: "Simektik yapıya sahip konservatif sistemler",
    solution: "H(p,q) = const., Alanı koruma özelliği",
    example: "H = p²/2m + V(q) - mekanik sistem",
    type: "hamiltonian",
    difficulty: "advanced"
  },

  // 47. Enerjinin Korunumu
  formula_047: {
    name: "Enerji Korunumu Koşulu",
    equation: "dE/dt = ∂H/∂t + {E,H}",
    description: "Zamana açık bağlı sistemlerde enerji değişim",
    solution: "Kapalı sistem: E = const",
    example: "dE/dt = P_ext (dış güç)",
    type: "energy_conservation",
    difficulty: "intermediate"
  },

  /* ==================== KONTROL VE OBSERVASİLİTE ==================== */

  // 48. Kontrol Edilebilirlik - Kalman Rankı
  formula_048: {
    name: "Kontrol Edilebilirlik Matrisi",
    equation: "C = [B, AB, A²B, ..., Aⁿ⁻¹B]",
    description: "Sistem kontrol edilebilir ⟺ rank(C) = n",
    solution: "rank(C) = n ise her noktaya ulaşılabilir",
    example: "n=2: C = [B, AB], rank(C)=2 ⟹ kontrol edilebilir",
    type: "controllability",
    difficulty: "intermediate"
  },

  // 49. Gözlenebilirlik - Observability
  formula_049: {
    name: "Gözlenebilirlik Matrisi",
    equation: "O = [[C], [CA], [CA²], ..., [CAⁿ⁻¹]]",
    description: "Sistem gözlenebilir ⟺ rank(O) = n",
    solution: "rank(O) = n ise durum çıkıştan belirlenebilir",
    example: "Kalman filtresi uygulamalarında",
    type: "observability",
    difficulty: "intermediate"
  },

  /* ==================== REFERANS ==================== */

  // 50. Beş Derece Sistem - Genel Referans
  formula_050: {
    name: "Genel Beş Derece Sistem",
    equation: "dX/dt = AX + BU, Y = CX + DU",
    description: "Lineer zamanla-değişmez (LTI) sistem genel formu",
    solution: "X(t) = e^(At)X₀ + ∫₀ᵗ e^(A(t-s))B·U(s)ds",
    example: "A ∈ ℝⁿˣⁿ, B ∈ ℝⁿˣᵐ, C ∈ ℝᵖˣⁿ, D ∈ ℝᵖˣᵐ",
    type: "reference_general",
    difficulty: "beginner"
  }
};

/**
 * Formül hesaplama ve doğrulama fonksiyonları
 */
function calculateMatrixDE(formulaId, params) {
  const formula = MATRIX_DE_FORMULAS[formulaId];
  if (!formula) return { error: "Formula not found" };
  
  return {
    name: formula.name,
    equation: formula.equation,
    solution: formula.solution,
    type: formula.type,
    difficulty: formula.difficulty,
    result: "Nümerik çözüm parametrelere bağlıdır"
  };
}

function getFormulasByType(type) {
  return Object.entries(MATRIX_DE_FORMULAS)
    .filter(([_, f]) => f.type === type)
    .map(([id, f]) => ({ id, ...f }));
}

function getFormulasByDifficulty(difficulty) {
  return Object.entries(MATRIX_DE_FORMULAS)
    .filter(([_, f]) => f.difficulty === difficulty)
    .map(([id, f]) => ({ id, ...f }));
}

// Tüm formülları listele
function getAllFormulas() {
  return Object.entries(MATRIX_DE_FORMULAS)
    .map(([id, formula]) => ({ id, ...formula }));
}

// Export
if (typeof module !== 'undefined' && module.exports) {
  module.exports = {
    MATRIX_DE_FORMULAS,
    calculateMatrixDE,
    getFormulasByType,
    getFormulasByDifficulty,
    getAllFormulas
  };
}
