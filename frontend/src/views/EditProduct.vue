<template>
    <div class="edit-product-container">
      <h1>Editar Produto</h1>
  
      <form @submit.prevent="updateProduct">
        <div class="form-group">
          <label for="name">Nome do Produto</label>
          <input type="text" id="name" v-model="product.name" required />
        </div>
  
        <div class="form-group">
          <label for="price">Preço</label>
          <input type="number" id="price" v-model.number="product.price" required />
        </div>
  
        <div class="form-group">
          <label for="category">Categoria</label>
          <input type="text" id="category" v-model="product.category" />
        </div>
  
        <div class="form-group">
          <label for="serialNumber">Número de Série</label>
          <input type="text" id="serialNumber" v-model="product.serial_number" required />
        </div>
  
        <div class="form-group">
          <label for="warrantyExpiryDate">Data de Expiração da Garantia</label>
          <input type="date" id="warrantyExpiryDate" v-model="product.warranty_expiry_date" required />
        </div>
  
        <div class="form-actions">
          <button type="submit" class="btn-submit">Salvar Alterações</button>
          <button type="button" @click="cancelEdit" class="btn-cancel">Voltar</button>
        </div>
      </form>
    </div>
  </template>
  
  <script>
  import axios from 'axios';
  
  export default {
    data() {
      return {
        product: {
          name: '',
          price: 0,
          category: '',
          serial_number: '',
          warranty_expiry_date: '',
        },
        isLoading: false,
      };
    },
  
    async mounted() {
      const productId = this.$route.params.productId;
      this.isLoading = true;
      try {
        const response = await axios.get(`http://localhost:4000/products/${productId}`, {
          headers: {
            Authorization: sessionStorage.getItem('Authorization'),
          },
        });
        this.product = response.data;
      } catch (error) {
        console.error('Erro ao carregar o produto:', error);
      } finally {
        this.isLoading = false;
      }
    },
  
    methods: {
      async updateProduct() {
        const productId = this.$route.params.productId;
        try {
          await axios.put(`http://localhost:4000/products/${productId}`, this.product, {
            headers: {
              Authorization: sessionStorage.getItem('Authorization'),
              'Content-Type': 'application/json',
            },
          });
          this.$router.push('/dashboard'); // Redireciona após a atualização
        } catch (error) {
          console.error('Erro ao atualizar o produto:', error);
        }
      },  
      cancelEdit() {
        this.$router.go(-1);
      },
    },
  };
  </script>

<style scoped>
/* Container principal da página */
.edit-product-container {
  padding: 20px;
  max-width: 600px;
  margin: 0 auto;
  background-color: #f9f9f9;
  border-radius: 10px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

h1 {
  text-align: center;
  font-size: 24px;
  color: #333;
  margin-bottom: 20px;
}

/* Estilos para o formulário */
form {
  display: flex;
  flex-direction: column;
}

/* Estilos para cada grupo de campo */
.form-group {
  margin-bottom: 15px;
}

.form-group label {
  font-weight: bold;
  display: block;
  margin-bottom: 5px;
  color: #555;
}

.form-group input {
  width: 100%;
  padding: 10px;
  margin-top: 5px;
  border-radius: 5px;
  border: 1px solid #ccc;
  font-size: 14px;
}

.form-group input:focus {
  border-color: #4CAF50;
  outline: none;
}

/* Estilos para os botões */
.form-actions {
  margin-top: 20px;
  display: flex;
  justify-content: space-between;
}

.btn-submit, .btn-cancel {
  padding: 10px 20px;
  border: none;
  border-radius: 5px;
  font-size: 16px;
  cursor: pointer;
  width: 48%;
}

.btn-submit {
  background-color: #4CAF50;
  color: white;
}

.btn-submit:hover {
  background-color: #45a049;
}

.btn-cancel {
  background-color: #f44336;
  color: white;
}

.btn-cancel:hover {
  background-color: #e53935;
}

/* Responsividade */
@media (max-width: 600px) {
  .edit-product-container {
    padding: 15px;
  }

  .btn-submit, .btn-cancel {
    width: 100%;
    margin-top: 10px;
  }
}
</style>

  