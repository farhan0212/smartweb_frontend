<script>
    import { goto } from '$app/navigation';

    function handleClick() {
        goto('/object-detection');
    }
    function handleClickAdminPage() {
        window.open(import.meta.env.VITE_API_URL_ADMIN, '_blank');
    }
</script>

<div class="min-h-screen flex flex-col justify-center items-center bg-gradient-to-br from-[#0f2027] to-[#2c5364] text-white font-orbitron tracking-wide">
    <h1 class="text-5xl mb-4 animate-pulse drop-shadow-[0_0_20px_#00ffe7] font-bold">
        🚀 Welcome to the Future
    </h1>
    <p class="mb-12 text-lg opacity-85">
        Experience futuristic object detection powered by SvelteKit.
    </p>
    
    <div class="flex flex-col sm:flex-row gap-6 items-center">
        <button
            class="group relative bg-gradient-to-r from-[#00ffe7] via-[#00d4ff] to-[#00bfff] text-[#0f2027] rounded-full px-12 py-5 text-xl font-bold shadow-[0_0_30px_rgba(0,255,231,0.5)] transition-all duration-300 hover:scale-110 hover:shadow-[0_0_50px_rgba(0,255,231,0.8)] hover:rotate-1 active:scale-95 border-2 border-transparent hover:border-[#00ffe7] overflow-hidden"
            on:click={handleClick}
        >
            <span class="relative z-10 flex items-center gap-3">
                🎯 Go to Object Detection
            </span>
            <div class="absolute inset-0 bg-gradient-to-r from-transparent via-white/20 to-transparent translate-x-[-100%] group-hover:translate-x-[100%] transition-transform duration-700 skew-x-12"></div>
        </button>
        
        <button 
            class="group relative bg-gradient-to-r from-[#ff6b6b] via-[#ff8e8e] to-[#ffa8a8] text-white rounded-full px-12 py-5 text-xl font-bold shadow-[0_0_30px_rgba(255,107,107,0.4)] transition-all duration-300 hover:scale-110 hover:shadow-[0_0_50px_rgba(255,107,107,0.7)] hover:rotate-[-1deg] active:scale-95 border-2 border-transparent hover:border-[#ff6b6b] overflow-hidden"
            on:click={handleClickAdminPage}
        >
            <span class="relative z-10 flex items-center gap-3">
                ⚙️ Go to Admin Panel
            </span>
            <div class="absolute inset-0 bg-gradient-to-r from-transparent via-white/20 to-transparent translate-x-[-100%] group-hover:translate-x-[100%] transition-transform duration-700 skew-x-12"></div>
        </button>
    </div>
</div>

<style>
    @import url('https://fonts.googleapis.com/css2?family=Orbitron:wght@700&display=swap');
    .font-orbitron {
        font-family: 'Orbitron', 'Segoe UI', Arial, sans-serif;
    }
</style>
