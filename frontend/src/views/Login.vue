<template>
  <div class="login-container">
    <h1>Login</h1>
    <form @submit.prevent="handleLogin">
      <input type="email" v-model="email" placeholder="Digite seu email" required />
      <input type="password" v-model="password" placeholder="Digite sua senha" required />
      <button type="submit">Entrar</button>
    </form>
    <p v-if="errorMessage" class="error">{{ errorMessage }}</p>

    <p>Não tem uma conta?
      <router-link to="/register">
        <button class="btn-register">Criar Conta</button>
      </router-link>
    </p>
  </div>
</template>

<script>
import api from '../services/axios';

export default {
  data() {
    return {
      email: '',
      password: '',
      errorMessage: null,
    };
  },
  methods: {
      async handleLogin() {
        try {
          const response = await api.post('/auth/sign_in', {
            email: this.email,
            password: this.password,
          });

          const headers = response.headers;

          const accessToken = headers['access-token'];
          const client = headers['client'];
          const uid = headers['uid'];

          if (!accessToken || !client || !uid) {
            throw new Error('Headers de autenticação ausentes.');
          }

          sessionStorage.setItem('access-token', accessToken);
          sessionStorage.setItem('client', client);
          sessionStorage.setItem('uid', uid);
          sessionStorage.setItem('user.name', response.data.data.name);

          this.password = ''; // Limpa a senha

          this.$router.push('/dashboard'); // Redireciona após login bem sucedido
        } catch (error) {
          console.error('Erro ao realizar login:', error);

          if (error.response?.data?.errors) {
            this.errorMessage = error.response.data.errors.join(', ');
          } else {
            this.errorMessage = 'Erro ao tentar fazer login. Verifique suas credenciais ou tente novamente.';
          }
        }
      },
  },
};
</script>

<style scoped>
.login-container {
  max-width: 600px;
  margin: 50px auto;
  padding: 50px;
  border: 1px solid #ddd;
  border-radius: 5px;
  background: #f9f9f9;
  text-align: center;
}

.login-container input {
  display: block;
  width: 100%;
  padding: 10px;
  margin: 10px 0;
}

.login-container button {
  padding: 10px 20px;
  background: #ff7f00;
  color: white;
  border: none;
  border-radius: 5px;
  cursor: pointer;
}

.error {
  color: red;
}
</style>
