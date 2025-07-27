<template>
  <div class="register-container">
    <h1>Criar Conta</h1>
    <form @submit.prevent="handleRegister">
      <input type="text" v-model="name" placeholder="Digite seu nome" required />
      <input type="email" v-model="email" placeholder="Digite seu email" required />
      <input type="password" v-model="password" placeholder="Digite sua senha" required />
      <input type="password" v-model="passwordConfirmation" placeholder="Confirme sua senha" required />
      <button type="submit">Registrar</button>
    </form>
    <p v-if="errorMessage" class="error">{{ errorMessage }}</p>
    <p>Já tem uma conta? <router-link to="/login">Login</router-link></p>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      name: '',
      email: '',
      password: '',
      passwordConfirmation: '',
      errorMessage: null,
    };
  },
  methods: {
    async handleRegister() {
      try {
        // Envia os dados para criar o usuário
        const response = await axios.post('http://localhost:4000/auth', {
          name: this.name,
          email: this.email,
          password: this.password,
          password_confirmation: this.passwordConfirmation,
        });

        // Sucesso no registro
        alert('Conta criada com sucesso! Faça login para continuar.');
        this.$router.push('/login'); // Redireciona para o login
      } catch (error) {
        if (error.response && error.response.data) {
          this.errorMessage = error.response.data.errors.full_messages.join(', ') || 'Erro ao criar conta.';
        } else {
          this.errorMessage = 'Erro de conexão. Tente novamente.';
        }
      }
    },
  },
};
</script>

<style scoped>
.register-container {
  max-width: 600px;
  margin: 50px auto;
  padding: 50px;
  border: 1px solid #ddd;
  border-radius: 5px;
  background: #f9f9f9;
  text-align: center;
}

.register-container input {
  display: block;
  width: 100%;
  padding: 10px;
  margin: 10px 0;
}

.register-container button {
  padding: 10px 20px;
  background: #007bff;
  color: white;
  border: none;
  border-radius: 5px;
  cursor: pointer;
}

.error {
  color: red;
}
</style>
