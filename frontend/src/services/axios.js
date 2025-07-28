import axios from 'axios';

const api = axios.create({
  baseURL: import.meta.env.VITE_API_URL,
   withCredentials: true,
});

api.interceptors.request.use(config => {
  const accessToken = sessionStorage.getItem('access-token');
  const client = sessionStorage.getItem('client');
  const uid = sessionStorage.getItem('uid');

  if (accessToken && client && uid) {
    config.headers['access-token'] = accessToken;
    config.headers['client'] = client;
    config.headers['uid'] = uid;
    config.headers['token-type'] = 'Bearer';
  }

  return config;
}, error => {
  return Promise.reject(error);
});

export default api;
