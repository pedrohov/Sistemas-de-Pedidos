/*
 * Sistemas Embarcados - 2o semestre/2018
 * Pedro Henrique Oliveira Veloso
 */

class Restaurante {
 
  String nome;
  ArrayList<String> garcons;
  ArrayList<Produto> produtos;
  ArrayList<Mesa> mesas;
  ArrayList<Pedido> pedidos;
  
  int pedidoIdSeed;
  
  Restaurante(String nome) {
    this.nome = nome;
    this.initProdutos();
    this.initMesas();
    this.initGarcons();
    this.pedidoIdSeed = 0;
    this.pedidos = new ArrayList<Pedido>();
    
    /*initMesa(1, new Cliente("Pedro"), "Joao");
    initMesa(5, new Cliente("Maria"), "Joao");
    novoPedido(5, "Coxinha", 2);
    novoPedido(5, "Cigarrete", 5);
    novoPedido(5, "Cafe", 1);*/
    
  }
  
  String getRandomGarcom() {
     int index = int(random(garcons.size()));
     String garcom = garcons.get(index);
     garcons.remove(index);
     
     return garcom;
  }
  
  void novoPedido(int mesa, String produto, int qtd) {
    // Buscar mesa:
    Mesa m = new Mesa();
    for(int i = 0; i < mesas.size(); i++)
      if(mesas.get(i).nome == mesa) {
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
    if((p.nome == null) || (m.nome <= 0) || (!m.ativa))
      return;
    
    Pedido pedido = new Pedido(pedidoIdSeed, p, m, qtd);
    m.addPedido(pedido); // Adiciona novo pedido a mesa correspondente.
    m.cliente.qtd_pedidos += 1;
    m.cliente.conta += p.preco;
    pedidos.add(pedido); // Adiciona novo pedido ao restaurante.
    
    pedidoIdSeed = pedidoIdSeed + 1;
  }
  
  void initMesa(int mesa, Cliente cliente) {
    for(int i = 0; i < mesas.size(); i++) {
      Mesa m = mesas.get(i); 
      if(m.nome == mesa) {
        m.ativa = true;
        m.cliente = cliente;
        m.garcom = getRandomGarcom();
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
  
  void drawPedidos(int iniX, int iniY) {
    
    int hspace = 125;
    int vspace = 40;
    int x = iniX;
    int y = iniY;
    
    for(int i = 0; i < pedidos.size(); i++) {
      pedidos.get(i).draw(x, y);
      x += hspace;
      
      if(x > 700) {
        x = iniX;
        y += vspace;
      }
    }
  }
  
  void drawPedidosMesa(int iniX, int iniY, Mesa m) {
    int hspace = 125;
    int vspace = 40;
    int x = iniX;
    int y = iniY;
    
    for(int i = 0; i < m.pedidos.size(); i++) {
      m.pedidos.get(i).draw(x, y);
      x += hspace;
      
      if(x > 550) {
        x = iniX;
        y += vspace;
      }
    }
  }
  
  void initProdutos() {
    produtos = new ArrayList<Produto>();
    
    Produto coxinha = new Produto("Coxinha", 3.5, 5);
    Produto cigarrete = new Produto("Cigarrete", 3, 5);
    Produto cafe = new Produto("Cafe", 0.5, 1);
    
    produtos.add(coxinha);
    produtos.add(cigarrete);
    produtos.add(cafe);
  }
  
  void initMesas() {
    mesas = new ArrayList<Mesa>();
    for(int i = 0; i < 27; i++) {
      Mesa m = new Mesa((i + 1), 70);
      mesas.add(m);
    }
  }
  
  void initGarcons() {
    garcons = new ArrayList<String>();
    garcons.add("João");
    garcons.add("Pedro");
    garcons.add("José");
    garcons.add("Maria");
    garcons.add("Rosvaldo");
    garcons.add("Lúcia");
    garcons.add("Mário");
    garcons.add("Antônio");
  }
  
}
