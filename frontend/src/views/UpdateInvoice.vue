<template>
    <div class="edit-invoice-container">
        <div class="form-container">
            <h1>Editar Nota Fiscal</h1>

            <!-- Formulário de edição -->
            <form @submit.prevent="updateInvoice">
                <div class="form-group">
                    <label for="invoiceNumber">Número da Nota Fiscal</label>
                    <input type="text" id="invoiceNumber" v-model="invoice.invoice_number" required />
                </div>

                <div class="form-group">
                    <label for="issueDate">Data de Emissão</label>
                    <input type="date" id="issueDate" v-model="invoice.issue_date" required />
                </div>
                <!-- Listagem de Produtos -->
                <div class="products-list">
                    <h2>Produto</h2>
                    <ul>
                        <li v-for="product in products" :key="product.id">
                            <div class="product-item">
                                <p><strong>Nome:</strong> {{ product.name }}</p>
                                <p><strong>Preço:</strong> R$ {{ product.price.toFixed(2) }}</p>
                                <p><strong>Loja:</strong> {{ product.store.name }}</p>
                                <p><strong>Categoria:</strong> {{ product.category }}</p>
                                <p><strong>Número de Série:</strong> {{ product.serial_number }}</p>
                                <p><strong>Data de Expiração da Garantia:</strong> {{ product.warranty_expiry_date }}
                                </p>
                                <button type="button" @click="editProduct(product.id)" class="btn-edit-product">Editar
                                    Produto</button>
                                <button type="button" @click="editStore(product.store.id)"
                                    class="btn-edit-store">Modificar Loja</button>
                            </div>
                        </li>
                    </ul>
                </div>

                <!-- Botões de ação -->
                <div class="form-actions">
                    <button type="submit" class="btn-submit">Salvar Alterações</button>
                    <button type="button" @click="cancelEdit" class="btn-cancel">Cancelar</button>
                </div>

                <!-- Carregando -->
                <p v-if="isLoading" class="loading">Carregando dados da nota fiscal...</p>

                <!-- Mensagem de sucesso ou erro -->
                <p v-if="message" class="message" :class="message.type">{{ message.text }}</p>
            </form>
        </div>
    </div>
</template>

<script>
import axios from 'axios';

export default {
    data() {
        return {
            invoice: {
                invoice_number: '',
                issue_date: '',
            },
            userName: sessionStorage.getItem('user.name') || 'nome',
            isLoading: false,  // Controle de loading
            message: null,  // Mensagem de sucesso ou erro

            products: [],  // Armazenará os produtos relacionados
        };
    },
    computed: {
        capitalizedUserName() {
            if (!this.userName) return '';
            return this.userName.charAt(0).toUpperCase() + this.userName.slice(1);
        },
    },
    methods: {
        // Carrega os dados da nota fiscal para edição
        async fetchInvoice() {
            const invoiceId = this.$route.params.id;

            this.isLoading = true;
            try {
                console.log('Carregando a nota fiscal...');

                // Carrega a nota fiscal
                const invoiceResponse = await axios.get(`http://localhost:4000/invoices/${invoiceId}`, {
                    headers: {
                        Authorization: sessionStorage.getItem('Authorization'),
                    },
                });
                this.invoice = invoiceResponse.data;

                // Carrega os produtos associados à nota fiscal
                const productResponse = await axios.get(`http://localhost:4000/products`, {
                    params: { q: { invoice_id_eq: invoiceId } },  // Aqui é usado o ransack
                    headers: {
                        Authorization: sessionStorage.getItem('Authorization'),
                    },
                });

                // Armazena os produtos associados à invoice
                this.products = productResponse.data;
                console.log('Produtos carregados:', this.products);

            } catch (error) {
                console.error('Erro ao carregar a nota fiscal:', error);
                this.message = { text: 'Erro ao carregar a nota fiscal.', type: 'error' };
            } finally {
                this.isLoading = false;
            }
        },

        fetchProductsByInvoice(invoiceId) {
            this.$axios.get(`/products`, {
                params: { q: { invoice_id_eq: invoiceId } },  // Aqui é usado o ransack
                headers: {
                    Authorization: sessionStorage.getItem('Authorization'),
                },
            })
                .then(response => {
                    this.products = response.data;  // Atualiza os produtos no Vue
                })
                .catch(error => {
                    console.error('Erro ao buscar produtos:', error);
                });
        },

        // Atualiza a nota fiscal
        async updateInvoice() {
            const invoiceId = this.$route.params.id;
            try {
                await axios.put(`http://localhost:4000/invoices/${invoiceId}`, this.invoice, {
                    headers: {
                        Authorization: sessionStorage.getItem('Authorization'),
                        'Content-Type': 'application/json',
                    },
                });
                this.message = { text: 'Nota fiscal atualizada com sucesso!', type: 'success' };
                this.$router.push('/dashboard');
            } catch (error) {
                console.error('Erro ao atualizar a nota fiscal:', error);
                this.message = { text: 'Falha ao atualizar a nota fiscal.', type: 'error' };
            }
        },

        // Função de edição de produto (a lógica pode ser expandida conforme necessidade)
        editProduct(productId) {
            this.$router.push(`/edit-product/${productId}`);
        },

        editStore(storeId) {
            console.log('ID da Loja:', storeId);
            this.$router.push(`/change-store/${storeId}`);
        },

        // Cancela a edição e retorna para a lista de notas fiscais
        cancelEdit() {
            this.$router.push('/dashboard');
        },
    },
    mounted() {
        this.fetchInvoice();
    },
};
</script>

<style scoped>
/* Estilos para o formulário */
.form-container {
    padding: 20px;
    max-width: 600px;
    margin: 0 auto;
    background-color: #c7c3c3;
    border-radius: 10px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.form-group {
    margin-bottom: 15px;
}

.form-group label {
    font-weight: bold;
    display: block;
}

.form-group input {
    width: 100%;
    padding: 10px;
    margin-top: 5px;
    border-radius: 5px;
    border: 1px solid #ccc;
}

.form-actions {
    margin-top: 20px;
    
}

.btn-submit {
    background-color: rgb(99, 163, 2);
    color: white;
    padding: 10px 20px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}

.btn-cancel {
    background-color: #ff0000;
    color: white;
    padding: 10px 20px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}

.btn-edit-product {
    background-color: #007bff;
    color: white;
    padding: 10px 20px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}

.product-item {
    background: #fff;
    padding: 20px;
    border: 1px solid #000000;
    border-radius: 15px;
    margin: 10px;
    box-shadow: 6px 10px 5px rgba(0, 0, 0, 0.4);
}

.form-actions {
    display: flex;
    justify-content: flex-end;    
    border-radius: 15px;
}
.loading {
    text-align: center;
    font-size: 16px;
    color: #888;
}

.message {
    margin-top: 20px;
    padding: 10px;
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

/* Estilo para Botões do Dashboard */
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

li {
    list-style: none;
}
</style>
