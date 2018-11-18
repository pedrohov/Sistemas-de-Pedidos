/*
 * Sistemas Embarcados - 2o semestre/2018
 * Pedro Henrique Oliveira Veloso
 */

class Produto {
 
  String nome;
  float preco;
  float tempoPreparo;
  
  Produto() {
    
  }
  
  Produto(String nome, float preco, float tempoPreparo) {
    this.nome  = nome; 
    this.preco = preco;
    this.tempoPreparo = tempoPreparo;
  }
  
}
