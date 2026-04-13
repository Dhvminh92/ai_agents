[2026-04-13] Cloud-First cho Heavy Compute

    Context: Laptop i5-5200U không chạy nổi local inference + debate cùng lúc
    Options: 
        Local-only model nhỏ
        Cloud-only trả phí
        Hybrid: Cloud cho task nặng, local cho orchestration + learning
    Decision: Option 3
    Reason: Tận dụng free tier, giảm tải local, học dần về local
    Impact: ✅ Tiết kiệm resource local, ⚠️ Cần router ổn định
    Review: 2026-07-01
    EOF
