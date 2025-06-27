<script>
  import { onMount } from "svelte";
  import * as tf from "@tensorflow/tfjs";
  import * as cocoSsd from "@tensorflow-models/coco-ssd";

  let videoRef;
  let canvasRef;
  let predictions = [];
  let model;
  let isProcessing = false;

  onMount(async () => {
    model = await cocoSsd.load();

    if (navigator.mediaDevices && navigator.mediaDevices.getUserMedia) {
      const stream = await navigator.mediaDevices.getUserMedia({
        video: true,
      });
      videoRef.srcObject = stream;
      detectObjects();
    }
  });

  async function detectObjects() {
    if (!model || !videoRef) return;

setInterval(async () => {
  predictions = await model.detect(videoRef); 
  drawBoundingBoxes();
}, 100);

  }

  function drawBoundingBoxes() {
    if (!canvasRef || !videoRef) return;

    const ctx = canvasRef.getContext("2d");
    ctx.clearRect(0, 0, canvasRef.width, canvasRef.height);

    ctx.drawImage(videoRef, 0, 0, canvasRef.width, canvasRef.height);

    predictions.forEach((pred) => {
      ctx.strokeStyle = "#00FF00";
      ctx.lineWidth = 2;
      ctx.strokeRect(pred.bbox[0], pred.bbox[1], pred.bbox[2], pred.bbox[3]);

      ctx.fillStyle = "#00FF00";
      ctx.font = "16px Arial";
      ctx.fillText(
        `${pred.class} (${Math.round(pred.score * 100)}%)`,
        pred.bbox[0],
        pred.bbox[1] > 10 ? pred.bbox[1] - 5 : 10
      );
    });
  }

 async function uploadDetection(prediction) {
  const payload = {
    predictions: prediction, 
  };

  try {
    const url = import.meta.env.VITE_API_URL;
    const res = await fetch(url, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(payload),
    });

    const data = await res.json();
    console.log("✅ Upload success:", data);
  } catch (error) {
    console.error("❌ Upload failed:", error);
  }
}


  async function handleTakePhoto() {
  try {
    if (
      videoRef?.readyState === 4 &&
      model &&
      predictions.length > 0
    ) {
      isProcessing = true;
      await uploadDetection(predictions.flat());
      
    } else {
      console.warn("Model not ready or no predictions.");
    }
  } catch (err) {
    console.error("Error during upload:", err);
  } finally {
    isProcessing = false;
  }
}


</script>

<div class="min-h-screen bg-gradient-to-br from-slate-900 via-slate-800 to-slate-900">
  <!-- Navigation -->
  <nav class="flex items-center justify-between px-8 py-6">
    <div class="text-white text-xl font-bold">
      FANI Innovations Technology
    </div>
    <!-- <div class="flex space-x-8">
      <a href="#" class="text-gray-300 hover:text-white transition-colors">Home</a>
      <a href="#" class="text-gray-300 hover:text-white transition-colors">About</a>
      <a href="#" class="text-gray-300 hover:text-white transition-colors">How It Works</a>
      <a href="#" class="text-gray-300 hover:text-white transition-colors">Contact</a>
    </div> -->
  </nav>

  <!-- Main Content -->
  <div class="px-8 py-16">
    <div class="max-w-7xl mx-auto">
      <!-- Hero Section -->
  <div class="min-h-screen flex flex-col lg:flex-row items-center justify-center gap-12 p-6 md:p-12 bg-gray-900">
  <!-- Left Column - Content -->
  <div class="max-w-xl lg:max-w-md xl:max-w-xl flex flex-col">
    <h1 class="text-4xl md:text-5xl lg:text-6xl font-bold text-white mb-6 leading-tight">
      AI-Powered Real-Time<br>
      <span class="bg-gradient-to-r from-pink-500 to-purple-600 bg-clip-text text-transparent">Object Detection</span>
    </h1>
    
    <p class="text-gray-300 text-lg mb-8">
      Our advanced computer vision system identifies and labels objects in real-time using your webcam. Powered by TensorFlow.js and the COCO-SSD model for accurate, instantaneous results.
    </p>
    
    <div class="flex flex-col sm:flex-row gap-4 mb-12">
<button 
  on:click={handleTakePhoto}
  class="flex-1 bg-gradient-to-r from-blue-500 to-blue-600 hover:from-blue-600 hover:to-blue-700 text-white px-6 py-3 rounded-lg font-medium transition-all duration-300 shadow-lg hover:shadow-xl flex items-center justify-center gap-2"
  disabled={isProcessing}
>
  <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
    <path d="M2 6a2 2 0 012-2h6a2 2 0 012 2v8a2 2 0 01-2 2H4a2 2 0 01-2-2V6zM14 6a2 2 0 012-2h2a2 2 0 012 2v8a2 2 0 01-2 2h-2a2 2 0 01-2-2V6z" />
  </svg>
  {isProcessing ? "Uploading..." : "Take Snapshot"}
</button>

    </div>
    
    <div class="bg-gray-800 rounded-xl p-4 border border-gray-700">
      <h3 class="text-white font-medium mb-2 flex items-center gap-2">
        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-purple-400" viewBox="0 0 20 20" fill="currentColor">
          <path fill-rule="evenodd" d="M11.3 1.046A1 1 0 0112 2v5h4a1 1 0 01.82 1.573l-7 10A1 1 0 018 18v-5H4a1 1 0 01-.82-1.573l7-10a1 1 0 011.12-.38z" clip-rule="evenodd" />
        </svg>
        Detection Features
      </h3>
      <ul class="text-gray-300 space-y-2 text-sm">
        <li class="flex items-start gap-2">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 mt-0.5 text-green-400 flex-shrink-0" viewBox="0 0 20 20" fill="currentColor">
            <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd" />
          </svg>
          <span>Identifies 80+ common objects with high accuracy</span>
        </li>
        <li class="flex items-start gap-2">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 mt-0.5 text-green-400 flex-shrink-0" viewBox="0 0 20 20" fill="currentColor">
            <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd" />
          </svg>
          <span>Runs entirely in your browser - no data leaves your device</span>
        </li>
        <li class="flex items-start gap-2">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 mt-0.5 text-green-400 flex-shrink-0" viewBox="0 0 20 20" fill="currentColor">
            <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd" />
          </svg>
          <span>Optimized for smooth performance on modern devices</span>
        </li>
      </ul>
    </div>
  </div>

  <!-- Right Column - Detection Interface -->
  <div class="w-full max-w-2xl space-y-6">
    <!-- Video Feed with Canvas Overlay -->
    <div class="relative bg-gray-800 rounded-xl overflow-hidden shadow-2xl border border-gray-700">
      <video
        bind:this={videoRef}
        width="640"
        height="480"
        autoplay
        muted
        playsinline
        class="w-full h-auto"
      >
        <track kind="captions" label="captions" />
      </video>
      <canvas
        bind:this={canvasRef}
        width="640"
        height="480"
        class="absolute top-0 left-0 w-full h-full pointer-events-none"
      ></canvas>
      
      <!-- Status Indicator -->
    
    </div>

    <!-- Detection Results -->
    <div class="bg-gray-800 rounded-xl p-6 shadow-2xl border border-gray-700">
      <div class="flex items-center justify-between mb-4">
        <h2 class="text-xl font-bold text-white flex items-center gap-2">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-purple-400" viewBox="0 0 20 20" fill="currentColor">
            <path d="M13.586 3.586a2 2 0 112.828 2.828l-.793.793-2.828-2.828.793-.793zM11.379 5.793L3 14.172V17h2.828l8.38-8.379-2.83-2.828z" />
          </svg>
          Detection Results
        </h2>
        <div class="text-sm text-gray-400">
          {predictions.length} {predictions.length === 1 ? 'object' : 'objects'} detected
        </div>
      </div>
      
      {#if predictions.length > 0}
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
          {#each predictions as pred}
            <div class="bg-gray-700/50 hover:bg-gray-700/70 rounded-lg p-3 transition-colors duration-200">
              <div class="flex items-center justify-between">
                <span class="font-medium text-white capitalize">{pred.class}</span>
                <span class="text-xs px-2 py-1 bg-purple-900/50 text-purple-300 rounded-full">
                  {(pred.score * 100).toFixed(0)}% confidence
                </span>
              </div>
              <div class="mt-1 h-1.5 w-full bg-gray-600 rounded-full overflow-hidden">
                <div 
                  class="h-full bg-gradient-to-r from-purple-500 to-pink-500" 
                  style="width: {(pred.score * 100)}%"
                ></div>
              </div>
            </div>
          {/each}
        </div>
      {:else}
        <div class="text-center py-8">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-12 w-12 mx-auto text-gray-500 mb-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9.172 16.172a4 4 0 015.656 0M9 10h.01M15 10h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
          </svg>
        </div>
      {/if}
    </div>
  </div>
</div>
      <!-- Video/Detection Area -->

      <!-- Feature Icons Section -->
      <div class="mt-24 grid grid-cols-1 md:grid-cols-3 gap-8">
        <!-- AI Brain Icon -->
        <div class="flex items-center space-x-4">
          <div class="w-16 h-16 bg-slate-700 rounded-full flex items-center justify-center">
            <svg class="w-8 h-8 text-gray-400" fill="currentColor" viewBox="0 0 24 24">
              <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/>
            </svg>
          </div>
          <div>
            <h3 class="text-white font-semibold">AI Powered</h3>
            <p class="text-gray-400 text-sm">Advanced machine learning</p>
          </div>
        </div>

        <!-- Loading/Processing Icon -->
        <div class="flex items-center space-x-4">
          <div class="w-16 h-16 bg-slate-700 rounded-full flex items-center justify-center">
            <svg class="w-8 h-8 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"/>
            </svg>
          </div>
          <div>
            <h3 class="text-white font-semibold">Real-Time</h3>
            <p class="text-gray-400 text-sm">Instant processing</p>
          </div>
        </div>

        <!-- COCO-SSD Model -->
        <div class="flex items-center space-x-4">
          <div class="w-16 h-16 bg-slate-700 rounded-full flex items-center justify-center">
            <svg class="w-8 h-8 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 3v2m6-2v2M9 19v2m6-2v2M5 9H3m2 6H3m18-6h-2m2 6h-2M7 19h10a2 2 0 002-2V7a2 2 0 00-2-2H7a2 2 0 00-2 2v10a2 2 0 002 2zM9 9h6v6H9V9z"/>
            </svg>
          </div>
          <div>
            <h3 class="text-white font-semibold">Uses</h3>
            <p class="text-white font-bold">COCO-SSD Model</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<style>
  video, canvas {
    border: 2px solid #333;
    margin: 10px;
  }
</style>