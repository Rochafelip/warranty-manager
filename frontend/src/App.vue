<script setup>
import { ref, onMounted } from 'vue';

const backendReady = ref(false);
const backendError = ref(false);

async function checkBackend() {
  try {
    const res = await fetch(import.meta.env.VITE_API_URL + '/auth/sign_in', {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
      },
    });

    if (res.ok || res.status === 204 || res.status === 401) {
      backendReady.value = true;
      backendError.value = false;
    } else {
      backendError.value = true;
    }
  } catch (error) {
    backendError.value = true;
  }
}

onMounted(() => {
  checkBackend();
});
</script>

<template>
  <div id="app">
    <div v-if="!backendReady && !backendError" class="loading-container">
      <div class="spinner"></div>
      <p>Conectando ao backend...</p>
    </div>

    <div v-else-if="backendError" class="error-container">
      <p>Erro ao conectar com o backend.</p>
      <button @click="checkBackend">Tentar novamente</button>
    </div>

    <router-view v-else />
  </div>
</template>

<style scoped>
.loading-container,
.error-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100vh;
  gap: 1rem;
  text-align: center;
}

.spinner {
  width: 48px;
  height: 48px;
  border: 6px solid #ccc;
  border-top-color: #42b883;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

button {
  background-color: #42b883;
  color: white;
  border: none;
  padding: 0.6rem 1.2rem;
  border-radius: 4px;
  cursor: pointer;
  font-weight: bold;
}

button:hover {
  background-color: #369f6c;
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}
</style>
