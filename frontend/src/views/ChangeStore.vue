<template>
    <div class="change-store-container">
      <h1>Alterar Loja dos Produtos</h1>
  
      <!-- Carregando informações -->
      <div v-if="isLoading">Carregando informações...</div>
  
      <!-- Mensagem de Feedback -->
      <div v-if="message.text" :class="['message', message.type]">
        {{ message.text }}
      </div>
  
      <!-- Formulário para alterar a loja dos produtos -->
      <form @submit.prevent="updateStore">
        <div class="product-list">
          <div
            class="product-item"
            v-for="product in products"
            :key="product.id"
          >
            <label>Produto: {{ product.name }}</label>
            <select v-model="product.store_id">
              <option
                v-for="store in stores"
                :key="store.id"
                :value="store.id"
              >
                {{ store.name }}
              </option>
            </select>
          </div>
        </div>
  
        <div class="form-actions">
          <button type="submit" class="btn-submit">Salvar Alterações</button>
          <button type="button" @click="cancelEdit" class="btn-cancel">Cancelar</button>
        </div>
      </form>
    </div>
  </template>
  
  <script>
  import axios from 'axios';
  
  export default {
    data() {
      return {
        invoice: {}, // Dados da nota fiscal (não usados diretamente aqui, mas podem ser úteis)
        products: [], // Lista de produtos associados à nota fiscal
        stores: [], // Lista de lojas disponíveis
        isLoading: false, // Indica se os dados estão sendo carregados
        message: { text: '', type: '' }, // Mensagem de feedback (sucesso ou erro)
      };
    },
    methods: {
      // Busca os produtos e as lojas disponíveis
      async fetchInvoiceAndStores() {
        const invoiceId = this.$route.params.id;
  
        this.isLoading = true;
        try {
          // Busca produtos associados à nota fiscal
          const productResponse = await axios.get('http://localhost:4000/products', {
            q: { invoice_id_eq: invoiceId }, // Ransack busca por "igual"
  
            headers: { Authorization: sessionStorage.getItem('Authorization') },
          });
          this.products = productResponse.data;
  
          // Busca todas as lojas
          const storeResponse = await axios.get('http://localhost:4000/stores', {
            headers: { Authorization: sessionStorage.getItem('Authorization') },
          });
          this.stores = storeResponse.data;
  
          console.log('Produtos carregados:', this.products);
          console.log('Lojas carregadas:', this.stores);
        } catch (error) {
          console.error('Erro ao carregar informações:', error);
          this.message = { text: 'Erro ao carregar os dados.', type: 'error' };
        } finally {
          this.isLoading = false;
        }
      },
  
      // Atualiza a loja dos produtos
      async updateStore() {
        try {
          for (const product of this.products) {
            await axios.put(
              `http://localhost:4000/products/${product.id}`,
              { store_id: product.store_id },
              {
                headers: {
                  Authorization: sessionStorage.getItem('Authorization'),
                  'Content-Type': 'application/json',
                },
              }
            );
          }
  
          this.message = {
            text: 'Lojas dos produtos atualizadas com sucesso!',
            type: 'success',
          };
          setTimeout(() => {
            this.$router.push('/dashboard'); // Redireciona para o dashboard
          }, 2000);
        } catch (error) {
          console.error('Erro ao atualizar as lojas:', error);
          this.message = {
            text: 'Erro ao atualizar as lojas dos produtos.',
            type: 'error',
          };
        }
      },
  
      // Cancela a edição e volta para o dashboard
      cancelEdit() {
        if (confirm('Você tem certeza que deseja cancelar as alterações?')) {
          this.$router.push('/dashboard');
        }
      },
    },
    mounted() {
      this.fetchInvoiceAndStores();
    },
  };
  </script>
  
  <style scoped>
  .change-store-container {
    max-width: 600px;
    margin: 2rem auto;
    padding: 1.5rem;
    background-color: #f9f9f9;
    border: 1px solid #ddd;
    border-radius: 5px;
  }
  
  .product-item {
    margin-bottom: 1rem;
  }
  
  .product-item select {
    width: 100%;
    padding: 0.5rem;
    margin-top: 0.5rem;
  }
  
  .form-actions {
    display: flex;
    justify-content: space-between;
    margin-top: 1.5rem;
  }
  
  .btn-submit {
    background-color: #4caf50;
    color: white;
    border: none;
    padding: 0.7rem 1.2rem;
    cursor: pointer;
    border-radius: 5px;
  }
  
  .btn-cancel {
    background-color: #f44336;
    color: white;
    border: none;
    padding: 0.7rem 1.2rem;
    cursor: pointer;
    border-radius: 5px;
  }
  
  .message {
    margin-bottom: 1rem;
    padding: 1rem;
    border-radius: 5px;
    text-align: center;
  }
  
  .message.success {
    background-color: #4caf50;
    color: white;
  }
  
  .message.error {
    background-color: #f44336;
    color: white;
  }
  </style>
  