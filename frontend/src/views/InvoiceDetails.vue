<template>
    <div class="app-container">
      <nav class="navbar">
        <div class="navbar-content">
          <div>
            <h1>Editar Nota Fiscal</h1>
          </div>
          <ul class="navbar-links">
            <li><a href="/dashboard">Dashboard</a></li>
            <li><a href="/invoices">Notas Fiscais</a></li>
            <li><a href="/profile">{{ capitalizedUserName }}</a></li>
            <li><a href="/logout">Sair</a></li>
          </ul>
        </div>
      </nav>
  
      <div class="dashboard-container">
        <h2>Detalhes da Nota Fiscal</h2>
        <div v-if="invoice" class="invoice-details">

          <div class="info-section">
            <p><strong>Nota Fiscal:</strong> {{ invoice.invoice_number }}</p>
            <p><strong>Data de Compra:</strong> {{ formatDate(invoice.purchase_date) }}</p>
            <p><strong>Data de Emissão:</strong> {{ formatDate(invoice.issue_date) }}</p>
              <p>
                <strong>Visualizar Nota Fiscal:</strong>
                <span v-if="invoice.pdf_url && invoice.pdf_url.length > 0">
                  <a :href="invoice.pdf_url" target="_blank" rel="noopener noreferrer" class="link">
                    Abrir PDF
                  </a>
                </span>
                <span v-else class="error-message">
                  PDF não disponível.
                </span>
              </p>
          </div>
  
          <h2>Produtos Comprados</h2>
          <ul class="products-list">
            <li v-for="product in products" :key="product.id" class="product-item">
              <div class="product-info">
                <strong>Nome:</strong> {{ product.name }}<br />
                <strong>Descrição:</strong> {{ product.description }}<br />
                <strong>Número de Série:</strong> {{ product.serial_number }}<br />
                <strong>Preço:</strong> R$ {{ formatPrice(product.price) }}<br />
                <strong>Garantia Válida até:</strong> {{ formatDate(product.warranty_expiry_date) }}<br />
              </div>

              <div class="store-info">
                <h4>Loja</h4>
                <strong>Nome:</strong> {{ product.store.name }}<br />
                <strong>Endereço:</strong> {{ product.store.address }}<br />
                <strong>Contato:</strong> {{ product.store.contact }}<br />
              </div>
            </li>
          </ul>
        </div>
        <button @click="$router.go(-1)" class="btn-icon">Voltar</button>
      </div>
    </div>
  </template>

  <script>
  import api from '../services/axios';

  export default {
    data() {
      return {
        invoice: null,
        isLoading: false,
      };
    },
    computed: {
      capitalizedUserName() {
        const name = localStorage.getItem('userName') || 'Usuário';
        return name.charAt(0).toUpperCase() + name.slice(1);
      },
      products() {
        return this.invoice?.products || [];
      },
    },
    methods: {
      formatDate(dateStr) {
        const options = { year: 'numeric', month: '2-digit', day: '2-digit' };
        return new Date(dateStr).toLocaleDateString('pt-BR', options);
      },
      formatPrice(price) {
        return Number(price).toFixed(2).replace('.', ',');
      },
    },
    async mounted() {
      this.isLoading = true;
      try {
        const response = await api.get(`/invoices?q[id_eq]=${this.$route.params.id}`);
        this.invoice = response.data[0] || null;
      } catch (error) {
        console.error('Erro ao buscar a nota fiscal:', error);
      } finally {
        this.isLoading = false;
      }
    },
  };
  </script>
  
  <style scoped>
  
  .navbar {
    background-color: #333;
    color: white;
    padding: 10px 20px;
    margin-bottom: 10px;
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
  
  .dashboard-container {
    background-color: #c7c3c3;
    padding: 20px;
    border-radius: 10px;
  }
  
  .btn-icon {
    padding: 10px 20px;
    background-color: #007bff;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
  }
  

  .error-message {
  color: red;
  font-weight: bold;
  }
  
  .btn-icon:hover {
    background-color: #0056b3;
  }
  
  .link {
    color: #007bff;
    text-decoration: none;
  }
  
  .products-list {
    list-style: none;
    padding: 0;
  }
  
  .product-item {
    background: #fff;
    padding: 20px;
    border: 1px solid #000000;
    border-radius: 15px;
    margin: 10px;
    box-shadow: 6px 10px 5px rgba(0, 0, 0, 0.4);
  }

  .product.info {
    padding: 10px;
  }
  </style>
  