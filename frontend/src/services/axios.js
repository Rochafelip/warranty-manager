// src/services/axios.js
import axios from 'axios';

const api = axios.create({
  baseURL: 'http://127.0.0.1:4000', // ajuste a URL da sua API
});

// Interceptor para adicionar tokens de autenticação em todas as requisições
api.interceptors.request.use(config => {
  const accessToken = sessionStorage.getItem('access-token');
  const client = sessionStorage.getItem('client');
  const uid = sessionStorage.getItem('uid');

  if (accessToken && client && uid) {
    config.headers['access-token'] = accessToken;
    config.headers['client'] = client;
    config.headers['uid'] = uid;
    config.headers['token-type'] = 'Bearer'; // geralmente token-type é 'Bearer'
  }

  return config;
}, error => {
  return Promise.reject(error);
});

export default api;
