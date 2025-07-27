<template>
  <!-- Navbar -->
  <nav class="navbar">
    <div class="navbar-content">
      <div>
        <h1>Criar Nota Fiscal</h1>
      </div>
      <ul class="navbar-links">
        <li><a href="/dashboard">Dashboard</a></li>
        <li><a href="/invoices">Notas Fiscais</a></li>
        <li><a href="/profile">{{ capitalizedUserName }}</a></li>
        <li><a href="/logout">Sair</a></li>
      </ul>
    </div>
  </nav>
  <div class="add-products-container">
    <h1>Adicionar Produtos</h1>
    <!-- Formulário para adicionar produtos -->
    <form @submit.prevent="addProduct">
      <div class="form-group">
        <label>Nome do Produto:</label>
        <input type="text" v-model="product.name" required />
      </div>
      <div class="form-group">
        <label>Descrição:</label>
        <input type="text" v-model="product.description" required />
      </div>
      <div class="form-group">
        <label>Categoria:</label>
        <input type="text" v-model="product.category" required />
      </div>
      <div class="form-group">
        <label>Preço:</label>
        <input type="number" v-model="product.price" required />
      </div>
      <div class="form-group">
        <label>Serial Number:</label>
        <input type="text" v-model="product.serial_number" required />
      </div>
      <div class="form-group">
        <label>Data de Expiração da Garantia:</label>
        <input type="date" v-model="product.warranty_expiry_date" required />
      </div>
      <div class="form-group">
        <label>Loja:</label>
        <select v-model="selectedStoreId">
          <option disabled value="">Selecione uma loja</option>
          <option v-for="store in stores" :key="store.id" :value="store.id">
            {{ store.name }}
          </option>
          <option value="new">Adicionar nova loja</option>
        </select>
      </div>

      <!-- Formulário para adicionar nova loja -->
      <div v-if="selectedStoreId === 'new'" class="new-store-form">
        <h2>Adicionar Nova Loja</h2>
        <div class="form-group">
          <label>Nome da Loja:</label>
          <input type="text" v-model="newStore.name" required />
        </div>
        <div class="form-group">
          <label>Contato:</label>
          <input type="email" v-model="newStore.contact" required />
        </div>
        <div class="form-group">
          <label>Endereço:</label>
          <input type="text" v-model="newStore.address" required />
        </div>
        <button type="button" @click="addNewStore" class="btn-primary">
          Salvar Loja
        </button>
      </div>

      <button type="submit" :disabled="isCreatingStore" class="btn-primary">
        Adicionar Produto
      </button>
      <button type="button" @click="goBack" class="btn-secondary">
        Voltar
      </button>
    </form>

    <ul class="product-list">
      <li v-for="(p, index) in productList" :key="index">
        {{ p.name }} - {{ p.quantity }} - {{ p.price }}
      </li>
    </ul>
  </div>
</template>

<script>
import axios from "axios";

export default {
  data() {
    return {
      product: {
        name: "",
        description: "",
        category: "",
        price: "",
        serial_number: "",
        warranty_expiry_date: "",
      },
      selectedStoreId: "", // ID da loja selecionada
      stores: [], // Lista de lojas disponíveis
      newStore: {
        name: "",
        contact: "",
        address: "",
      },
      productList: [],
      isCreatingStore: false, // Para bloquear o botão enquanto a loja está sendo criada
    };
  },
  props: ["invoiceId"],
  methods: {
    async fetchStores() {
      try {
        const authorizationHeader = sessionStorage.getItem("Authorization");
        const response = await axios.get("http://localhost:4000/stores", {
          headers: { Authorization: authorizationHeader },
        });
        this.stores = response.data;
      } catch (error) {
        console.error("Erro ao buscar lojas:", error);
      }
    },
    async addNewStore() {
      try {
        this.isCreatingStore = true; // Bloqueia ações enquanto a loja está sendo criada
        const authorizationHeader = sessionStorage.getItem("Authorization");
        const response = await axios.post(
          "http://localhost:4000/stores",
          { store: this.newStore },
          {
            headers: { Authorization: authorizationHeader },
          }
        );

        // Adiciona a nova loja à lista e seleciona automaticamente
        this.stores.push(response.data);
        this.selectedStoreId = response.data.id;

        // Reseta os campos do formulário de nova loja
        this.newStore = { name: "", contact: "", address: "" };
        alert("Loja criada com sucesso!");
      } catch (error) {
        alert("Erro ao criar a loja.");
      } finally {
        this.isCreatingStore = false;
      }
    },
    async addProduct() {
      try {
        const authorizationHeader = sessionStorage.getItem("Authorization");
        const productData = {
          ...this.product,
          store_id: this.selectedStoreId,
          invoice_id: this.invoiceId,
        };

        const response = await axios.post(
          "http://localhost:4000/products",
          { product: productData },
          {
            headers: {
              Authorization: authorizationHeader,
              "Content-Type": "application/json",
            },
          }
        );

        this.productList.push(response.data);
        this.product = {
          name: "",
          description: "",
          category: "",
          price: "",
          serial_number: "",
          warranty_expiry_date: "",
        };
        alert("Produto adicionado com sucesso!");
      } catch (error) {
        alert("Erro ao adicionar o produto.");
      }
    },
    goBack() {
      this.$router.go(-1); // Voltar à página anterior
    },
  },
  mounted() {
    this.fetchStores(); // Busca as lojas ao montar o componente
  },
};
</script>

<style scoped>
/* Navbar */
.navbar {
  background-color: #333;
  color: white;
  padding: 10px 20px;
  margin-bottom: 20px;
  border-radius: 10px;
}

.navbar-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.navbar-links {
  list-style: none;
  display: flex;
  gap: 15px;
}

.navbar-links a {
  color: white;
  text-decoration: none;
}

.add-products-container {
  max-width: 700px;
  margin: 50px auto;
  padding: 20px;
  background-color: rgb(199, 195, 195);
  border-radius: 8px;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

h1 {
  text-align: center;
  color: #ff6600;
  margin-bottom: 20px;
}

form {
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.form-group {
  display: flex;
  flex-direction: column;
}

label {
  font-weight: bold;
  color: #ff6600;
  margin-bottom: 5px;
}

input,
select {
  padding: 10px;
  border: 1px solid rgb(83, 82, 82);
  border-radius: 4px;
  font-size: 16px;
}

button {
  padding: 10px 15px;
  font-size: 16px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

button.btn-primary {
  background-color: #ff6600;
  color: #ffffff;
  transition: background-color 0.3s;
}

button.btn-primary:hover {
  background-color: darkorange;
}

button.btn-secondary {
  background-color: var(--gray-medium);
  color: var(--gray-dark);
  margin-top: 10px;
  border: 1px solid var(--gray-dark);
}

button.btn-secondary:hover {
  background-color: var(--gray-dark);
  color: var(--white);
}

.product-list {
  margin-top: 20px;
  padding: 0;
  list-style: none;
}

.product-list li {
  padding: 10px;
  border-bottom: 1px solid var(--gray-dark);
}

.product-list li:last-child {
  border-bottom: none;
}
</style>
