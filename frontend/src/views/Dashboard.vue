<template>
  <div class="app-container">
    <nav class="navbar">
      <div class="navbar-content">
        <div>
          <h1>Minhas Notas Fiscais</h1>
        </div>
        <ul class="navbar-links">
          <li><router-link to="/dashboard">Dashboard</router-link></li>
          <li><router-link to="/invoices">Notas Fiscais</router-link></li>
          <li><router-link to="/profile">{{ capitalizedUserName }}</router-link></li>
          <li>
            <a href="#" @click.prevent="logout">Sair</a>
          </li>
        </ul>
      </div>
    </nav>

    <div class="dashboard-container">
      <div class="actions">
        <button @click="addInvoice">Adicionar Nota Fiscal</button>
        <button @click="fetchInvoices">Sincronizar Notas Fiscais</button>
      </div>

      <p v-if="isLoading" class="loading">Carregando notas fiscais...</p>

      <table v-if="invoices.length > 0 && !isLoading" class="invoice-table">
        <thead>
          <tr>
            <th>Número</th>
            <th>Data</th>
            <th>Produto</th>
            <th>Loja</th>
            <th>Valor</th>
            <th>Status</th>
            <th>Ações</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="invoice in invoices" :key="invoice.id">
            <td class="invoice-number">{{ invoice.invoice_number }}</td>
            <td>{{ formatDate(invoice.issue_date) }}</td>
            <td>
              <ul v-if="invoice.products.length">
                <li v-for="product in invoice.products" :key="product.id">{{ product.name }}</li>
              </ul>
              <span v-else>Sem produtos</span>
            </td>
            <td>
              <ul v-if="invoice.products.length">
                <li v-for="product in invoice.products" :key="product.id">{{ product.store?.name || '--' }}</li>
              </ul>
              <span v-else>--</span>
            </td>
            <td>
              <ul v-if="invoice.products.length">
                <li v-for="product in invoice.products" :key="product.id">R$ {{ product.price?.toFixed(2) || '0.00' }}</li>
              </ul>
              <span v-else>--</span>
            </td>
            <td>
              <ul v-if="invoice.products.length">
                <li v-for="product in invoice.products" :key="product.id">{{ checkWarrantyStatus(product.warranty_expiry_date) }}</li>
              </ul>
              <span v-else>--</span>
            </td>
            <td class="actions-cell">
              <button @click="viewDetails(invoice.id)" class="btn-icon" title="Visualizar">
                <i class="fas fa-eye"></i>
              </button>
              <button @click="editInvoice(invoice.id)" class="btn-icon edit" title="Editar">
                <i class="fas fa-edit"></i>
              </button>
              <button @click="deleteInvoice(invoice.id)" class="btn-icon delete" title="Excluir">
                <i class="fas fa-trash-alt"></i>
              </button>
            </td>
          </tr>
        </tbody>
      </table>

      <p v-else-if="!isLoading" class="no-data">Você não tem notas fiscais registradas.</p>
    </div>
  </div>
</template>
<script>
import api from '../services/axios';

export default {
  data() {
    return {
      userName: sessionStorage.getItem('user.name') || 'usuário',
      invoices: [],
      isLoading: false,
    };
  },
  computed: {
    capitalizedUserName() {
      return this.userName.charAt(0).toUpperCase() + this.userName.slice(1);
    },
  },
  methods: {
    formatDate(date) {
      const d = new Date(date);
      return d.toLocaleDateString('pt-BR');
    },

    checkWarrantyStatus(expiryDate) {
      const today = new Date();
      const expiry = new Date(expiryDate);
      return expiry < today ? 'Expirada' : 'Válida';
    },

    async fetchInvoices() {
      this.isLoading = true;
      try {
        const [invoiceRes, productRes] = await Promise.all([
          api.get('/invoices'),
          api.get('/products'),
        ]);

        const invoices = invoiceRes.data;
        const products = productRes.data;

        // Associa produtos + loja direto para cada invoice
        invoices.forEach(invoice => {
          invoice.products = products.filter(p => p.invoice_id === invoice.id);
        });

        this.invoices = invoices;
      } catch (error) {
        console.error('Erro ao buscar notas fiscais:', error);
        alert('Erro ao buscar as notas fiscais. Verifique se está autenticado.');
      } finally {
        this.isLoading = false;
      }
    },
    async logout() {
      try {
        await api.delete('/auth/sign_out', {
          headers: {
            'access-token': sessionStorage.getItem('access-token'),
            client: sessionStorage.getItem('client'),
            uid: sessionStorage.getItem('uid'),
          }
        });

        sessionStorage.clear();
        this.$router.push('/login'); // redireciona para a página de login
      } catch (error) {
        console.error('Erro ao fazer logout:', error);
        alert('Não foi possível fazer logout. Tente novamente.');
      }
    },

    addInvoice() {
      this.$router.push('/create-invoice');
    },

    viewDetails(id) {
      this.$router.push({ name: 'InvoiceDetails', params: { id } });
    },

    editInvoice(id) {
      this.$router.push(`/invoices/${id}/edit`);
    },

    async deleteInvoice(id) {
      if (!confirm("Tem certeza que deseja excluir esta nota fiscal?")) return;
      try {
        await api.delete(`/invoices/${id}`);
        alert("Nota fiscal excluída com sucesso!");
        this.fetchInvoices();
      } catch (err) {
        console.error("Erro ao excluir a nota fiscal:", err);
        alert("Erro ao excluir. Verifique sua conexão ou permissões.");
      }
    }
  },
  mounted() {
    this.fetchInvoices();
  }
};
</script>

<style scoped>
.btn-icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 8px 12px;
  background-color: #ff6600;
  color: #fff;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  font-size: 14px;
  transition: background-color 0.3s ease, transform 0.2s ease;
  margin-right: 5px;
}

.btn-icon.edit {
  background-color: #ffc107;
  color: #fff;
}

.btn-icon.edit:hover {
  background-color: #e0a800;
}

.btn-icon.delete {
  background-color: #dc3545;
  margin-right: 0;
}

.btn-icon:hover {
  background-color: #ff6600;
  transform: scale(1.05);
}

.btn-icon.delete:hover {
  background-color: #b21f2d;
  transform: scale(1.05);
}

/* Navbar */
.navbar {
  background-color: #333;
  color: white;
  padding: 10px 20px;
  margin-bottom: 10px;
  margin-top: 5px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  border-radius: 10px;
  flex-wrap: wrap;
}

.navbar-content {
  display: flex;
  justify-content: space-between;
  width: 100%;
  flex-wrap: wrap;
  align-items: center;
}

.navbar-links {
  list-style-type: none;
  display: flex;
  gap: 15px;
  margin: 10px;
  padding: 0;
}

.navbar-links li a {
  color: white;
  text-decoration: none;
  font-size: 16px;
}

.navbar-links li a:hover {
  text-decoration: underline;
}

/* Responsividade para Navbar */
@media (max-width: 768px) {
  .navbar-links {
    flex-direction: column;
    gap: 10px;
  }
  .navbar-links li {
    text-align: center;
  }
}

/* Container do Dashboard */
.dashboard-container {
  padding: 20px;
  background-color: rgb(199, 195, 195);
  border-radius: 10px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

/* Botões do Dashboard */
button {
  padding: 10px 20px;
  background-color: #ff6600;
  color: white;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  margin-bottom: 20px;
  margin-right: 15px;
  transition: background-color 0.3s ease, transform 0.2s ease;
}

button:hover {
  background-color: #e65c00;
  transform: translateY(-2px);
}

/* Tabela */
table {
  width: 100%;
  border-collapse: collapse;
  margin-top: 20px;
  background-color: rgb(252, 217, 193);
  border-radius: 5px;
  overflow: hidden;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

th, td {
  padding: 15px;
  border: 1px solid #000000;
  text-align: center;
}

th {
  background-color: #f4f4f4;
  font-weight: bold;
}

td ul {
  padding: 0;
  list-style-type: none;
  margin: 0;
}

.invoice-number {
  font-weight: bold;
}

.loading {
  font-weight: bold;
  margin-top: 15px;
}

.no-data {
  margin-top: 20px;
  font-style: italic;
  color: #555;
}

/* Responsividade para tabela */
@media (max-width: 768px) {
  table, thead, tbody, th, td, tr {
    display: block;
  }
  th, td {
    width: 100%;
    display: flex;
    justify-content: space-between;
    padding: 10px;
    box-sizing: border-box;
  }
  th {
    background-color: #f4f4f4;
    font-weight: bold;
    border-bottom: 2px solid #ddd;
  }
  td {
    border-bottom: 1px solid #ddd;
  }
}
</style>
