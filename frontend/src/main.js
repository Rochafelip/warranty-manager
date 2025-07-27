import { createApp } from 'vue';
import App from './App.vue';
import router from './router';

console.log('Session Storage Initial State:', sessionStorage.getItem('access-token')); // Verifica se o token está presente

const app = createApp(App);

app.use(router);

app.mount('#app');
