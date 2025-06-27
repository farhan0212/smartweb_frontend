<script>
    import { goto } from '$app/navigation';

    function handleClick() {
        goto('/object-detection');
    }
</script>

<div class="min-h-screen flex flex-col justify-center items-center bg-gradient-to-br from-[#0f2027] to-[#2c5364] text-white font-orbitron tracking-wide">
    <h1 class="text-5xl mb-4 animate-pulse drop-shadow-[0_0_20px_#00ffe7] font-bold">
        🚀 Welcome to the Future
    </h1>
    <p class="mb-8 text-lg opacity-85">
        Experience futuristic object detection powered by SvelteKit.
    </p>
    <button
        class="bg-gradient-to-r from-[#00ffe7] to-[#00bfff] text-[#0f2027] rounded-full px-10 py-4 text-lg font-bold shadow-lg transition-transform duration-200 hover:scale-110 hover:shadow-2xl"
        on:click={handleClick}
    >
        Go to Object Detection
    </button>
</div>

<style>
    @import url('https://fonts.googleapis.com/css2?family=Orbitron:wght@700&display=swap');
    .font-orbitron {
        font-family: 'Orbitron', 'Segoe UI', Arial, sans-serif;
    }
</style>
