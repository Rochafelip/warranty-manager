import { createRouter, createWebHistory } from 'vue-router';
import Login from '../views/Login.vue'; // Importe o componente de Login
import Dashboard from '../views/Dashboard.vue'; // Importe o componente de Dashboard
import Register from '../views/Register.vue'; // Importe o componente de Register
import CreateInvoice from '../views/CreateInvoice.vue'; // Página para criar nota fiscal
import CreateProduct from '../views/CreateProduct.vue';
import InvoiceDetails from '../views/InvoiceDetails.vue';
import UpdateInvoice from '../views/UpdateInvoice.vue';
import EditProduct from '../views/EditProduct.vue';
import ChangeStore from '../views/ChangeStore.vue';

const routes = [
  {
    path: '/',
    redirect: '/login', // Redireciona explicitamente para a rota de login
  },
  {
    path: '/login',
    name: 'Login',
    component: Login,
  },
  {
    path: '/register', 
    name: 'Register',
    component: Register,
  },
  {
    path: '/dashboard',
    name: 'Dashboard',
    component: Dashboard,
    meta: { requiresAuth: true }, // Requer autenticação
  },
  {
    path: '/create-invoice',
    name: 'CreateInvoice',
    component: CreateInvoice,
    meta: { requiresAuth: true }, // Proteger rota por autenticação
  },
  {
    path: '/add-products/:invoiceId',
    name: 'CreateProduct',
    component: CreateProduct,
    props: true,
    meta: { requiresAuth: true }, 
  },
  {
    path: '/invoice-details/:id',  
    name: 'InvoiceDetails',
    component: InvoiceDetails,
    props: true,  
  },
  {
    path: '/invoices/edit/:id',
    name: 'UpdateInvoice',
    component: UpdateInvoice,
    props: true, // Permite passar o 'id' como prop
    meta: { requiresAuth: true },
  },
  {
    path: '/edit-product/:productId',
    name: 'EditProduct',
    component: EditProduct,
    props: true, // Permite passar o 'productId' como prop
    meta: { requiresAuth: true },
  },
  {
    path: '/change-store/:storeId',
    name: 'ChangeStore',
    component: ChangeStore,    
    props: true, 
    meta: { requiresAuth: true },
  },
  // {
  //   path: '/add-store/:invoiceId',
  //   name: 'AddStore',
  //   component: () => import('@/views/AddStore.vue'),
  //   props: true,
  // },

];

const router = createRouter({
  history: createWebHistory(), // Usa o histórico da web
  routes, // Define as rotas
});

router.beforeEach((to, from, next) => {
  const isLoggedIn = sessionStorage.getItem('access-token'); // Verifica se o token existe

  // Se o usuário está acessando uma página que requer autenticação, mas não está logado
  if (to.meta.requiresAuth && !isLoggedIn) {
    next('/login'); // Redireciona para a página de login
  }
  // Se o usuário está tentando acessar Login ou Register já logado, redireciona para o Dashboard
  else if ((to.name === 'Login' || to.name === 'Register') && isLoggedIn) {
    next('/dashboard');
  }
  // Permite navegação para todas as outras rotas
  else {
    next();
  }
});

export default router;