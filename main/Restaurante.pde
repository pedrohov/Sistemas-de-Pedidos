/*
 * Sistemas Embarcados - 2o semestre/2018
 * Pedro Henrique Oliveira Veloso
 */

class Restaurante {
 
  String nome;
  String[] garcons = {"João", "Pedro", "José", "Maria", "Rosvaldo", "Lúcia", "Mário", "Antônio"};
  ArrayList<Produto> produtos;
  ArrayList<Mesa> mesas;
  
  Restaurante(String nome) {
    this.nome = nome;
    this.initProdutos();
    this.initMesas();
    
    initMesa("1", new Cliente("Pedro"), "Joao");
    initMesa("5", new Cliente("Maria"), "Joao");
    novoPedido("5", "Coxinha", 2);
  }
  
  void novoPedido(String mesa, String produto, int qtd) {
    // Buscar mesa:
    Mesa m = new Mesa();
    for(int i = 0; i < mesas.size(); i++)
      if(mesas.get(i).nome.equals(mesa)) {
        m = mesas.get(i);
        break;
      }
    
    // Buscar produto:
    Produto p = new Produto();
    for(int i = 0; i < produtos.size(); i++)
      if(produtos.get(i).nome.equals(produto)) {
        p = produtos.get(i);
        break;
      }
      
    // Verificar se mesa e produtos sao validos:
    if((m.nome == null) || (p.nome == null))
      return;
      
    m.pedido = new Pedido(p, m, qtd);
  }
  
  void initMesa(String mesa, Cliente cliente, String garcom) {
    for(int i = 0; i < mesas.size(); i++) {
      Mesa m = mesas.get(i); 
      
      if(m.nome.equals(mesa)) {
        m.ativa = true;
        m.cliente = cliente;
        break;
      }  
    }
  }
  
  void drawMesas(int iniX, int iniY) {
    
    int hspace = 80;
    int vspace = 80;
    int x = iniX;
    int y = iniY;
    
    for(int i = 0; i < mesas.size(); i++) {
      mesas.get(i).draw(x, y);
      x += hspace;
      
      if(x > 700) {
        x = iniX;
        y += vspace;
      }
    }
  }
  
  void initProdutos() {
    produtos = new ArrayList<Produto>();
    
    Produto coxinha = new Produto("Coxinha", 3.5, 5);
    Produto cigarrete = new Produto("Cigarrete", 3, 5);
    Produto cafe = new Produto("Café", 0.5, 0.5);
    
    produtos.add(coxinha);
    produtos.add(cigarrete);
    produtos.add(cafe);
  }
  
  void initMesas() {
    mesas = new ArrayList<Mesa>();
    for(int i = 0; i < 20; i++) {
      Mesa m = new Mesa(Integer.toString(i + 1), 70);
      mesas.add(m);
    }
  }
  
}
