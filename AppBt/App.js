import React, { Component } from 'react';
import {
  Platform,
  StyleSheet,
  Text,
  View,
  ScrollView,
  Button,
  FlatList,
  Switch,
  TouchableOpacity,
  ToastAndroid,
  TextInput,
  Picker,
  Animated,
  Alert
} from 'react-native';

var _ = require('lodash');
import BluetoothSerial from 'react-native-bluetooth-serial'
import NumericInput from 'react-native-numeric-input'
import {Icon} from 'react-native-elements'

class Pedido extends Component {

  render() {
    return (
      <View>
        <Text>{nome}</Text>
      </View>
    )
  }
}

export default class App extends Component<{}> {
  
  constructor (props) {
    super(props)
    this.state = {
      isEnabled: false,
      discovering: false,
      devices: [],
      unpairedDevices: [],
      connected: false,
      nomeCliente: "Cliente",
      message: "",
      item: "",
      quantidade: 1,
      pedidos: [],
      disabled: false,
      id: -1,
      status: "",
      mesa: "1"
    }
    this.animatedValue = new Animated.Value(0);
    this.index = 0;
  }

  componentWillMount(){

    Promise.all([
      BluetoothSerial.isEnabled(),
      BluetoothSerial.list()
    ])
    .then((values) => {
      const [ isEnabled, devices ] = values

      this.setState({ isEnabled, devices })
    })

    BluetoothSerial.on('bluetoothEnabled', () => {

      Promise.all([
        BluetoothSerial.isEnabled(),
        BluetoothSerial.list()
      ])
      .then((values) => {
        const [ isEnabled, devices ] = values
        this.setState({  devices })
      })

      BluetoothSerial.on('bluetoothDisabled', () => {

         this.setState({ devices: [] })

      })
      BluetoothSerial.on('error', (err) => console.log(`Error: ${err.message}`))
    
    })

    BluetoothSerial.withDelimiter('\n').then(() => {
        Promise.all([
        BluetoothSerial.isEnabled(),
        BluetoothSerial.list()
      ])
      .then((values) => {
        const [ isEnabled, devices ] = values
        this.setState({  devices })
      })
          BluetoothSerial.on('read', data => {
            this.handleReceivedMessage(data);
         });
    });
  }

  connect (device) {
    this.setState({ connecting: true })
    BluetoothSerial.connect(device.id)
    .then((res) => {
      console.log(`Connected to device ${device.name}`);
      this.setState({ connected: true })
      ToastAndroid.show(`Connected to device ${device.name}`, ToastAndroid.SHORT);
      var msg = '{{CLIENTE}},' + this.state.mesa + "," + this.state.nomeCliente;
      this.sendMessage(msg);
    })
    .catch((err) => console.log((err.message)))
  }

  enable () {
    BluetoothSerial.enable()
    .then((res) => this.setState({ isEnabled: true }))
    .catch((err) => Toast.showShortBottom(err.message))
  }

  disable () {
    BluetoothSerial.disable()
    .then((res) => this.setState({ isEnabled: false }))
    .catch((err) => Toast.showShortBottom(err.message))
  }

  toggleBluetooth (value) {
    if (value === true) {
      this.enable()
    } else {
      this.disable()
    }
  }

  discoverAvailableDevices () {
    
    if (this.state.discovering) {
      return false
    } else {
      this.setState({ discovering: true })
      BluetoothSerial.discoverUnpairedDevices()
      .then((unpairedDevices) => {
        const uniqueDevices = _.uniqBy(unpairedDevices, 'id');
        console.log(uniqueDevices);
        this.setState({ unpairedDevices: uniqueDevices, discovering: false })
      })
      .catch((err) => console.log(err.message))
    }
  }

  novoPedido () {
    if(this.state.item !== '') {
      var msg = '{{PEDIDO}},' + this.state.mesa + ',' + this.state.item + ',' + this.state.quantidade;
      this.addPedido();
      this.sendMessage(msg);
    } else {
      Alert.alert('Pedido não enviado', 'Selecione um item');
    }
  }

  addPedido () {
    this.animatedValue.setValue(0)

    let newPedido = { id: this.state.id, item: this.state.item, quantidade: this.state.quantidade, status: "PENDENTE" }

    this.setState({ disabled: true, pedidos: [...this.state.pedidos, newPedido]}, () => {
      Animated.timing(
        this.animatedValue, {
          toValue: 1,
          duration: 500,
          useNativeDriver: true
        }
      ).start(() => {
        this.index = this.index + 1;
        this.setState({ disabled: false });
      })
    });
  }

  receberPedido (item) {
    // Informa que o pedido despachado foi recebido pelo cliente:
    if(item.id >= 0 && (item.status === "DESPACHADO")) {
      var msg = '{{RECEBID}},' + item.id.toString() + ",";
      item.status = "ENTREGUE";
      this.sendMessage(msg);
    }
  }

  handleReceivedMessage(data) {
    var msg = data.data;
    var comando = msg.substring(0, 11);

    if(comando === "{{0BUZZER}}") {
      var indexFim = msg.indexOf(',', 12);
      var id = parseInt(msg.substring(12, indexFim));
      var indexFimStatus = msg.indexOf('\n', indexFim) - 1;

      // Atualiza o Id do pedido enviado:
      this.state.status = msg.substring(indexFim + 1, indexFimStatus);
      this.state.pedidos[this.state.pedidos.length - 1].id = id;
      this.setState(this.state) // Renderiza a tela novamente.

      //Alert.alert("Status do Pedido", `O seu pedido #${id} foi enviado.`);
      
    } else if(comando == "{{ALTERAC}}") {
      var indexFim = msg.indexOf(',', 12);
      var id = parseInt(msg.substring(12, indexFim));
      var indexFimStatus = msg.indexOf('\n', indexFim) - 1;
      var novoStatus = msg.substring(indexFim + 1, indexFimStatus);


      for(var i = 0; i < this.state.pedidos.length; i++) {
        if(this.state.pedidos[i].id === id) {
          this.state.pedidos[i].status = novoStatus;
          this.setState(this.state) // Renderiza a tela novamente.

          Alert.alert("Status do Pedido", `O seu pedido #${id} foi ${novoStatus}`);
          break;
        }
      }
    }
  }

  sendMessage (msg) {
    if(this.state.connected) {
      BluetoothSerial.write(msg)
      .then((res) => {
        this.setState({ connected: true })
      })
      .catch((err) => console.log(err.message))
    }
  }

  _renderItem (item){
    return(
        <TouchableOpacity onPress={() => this.connect(item.item)}>
          <View style={styles.deviceNameWrap}>
            <Text style={styles.deviceName}>{ item.item.name ? item.item.name : item.item.id }</Text>
          </View>
        </TouchableOpacity>
    )
  }

  render() {

    const animationValue = this.animatedValue.interpolate(
    {
      inputRange: [ 0, 1],
      outputRange: [ -59, 0]
    });

    let newArray = this.state.pedidos.map(( item, key ) =>
    {
        if(item.id >= 0) {
          if(( key ) === this.index)
          {
              return(
                  <Animated.View key = { key } style = {[{ opacity: this.animatedValue, transform: [{ translateY: animationValue }] }]}>
                      <Text style={(item.status == "PENDENTE")   ? styles.viewPendente   : 
                                  ((item.status == "ATENDIDO")   ? styles.viewAtendido   : 
                                  ((item.status == "DESPACHADO") ? styles.viewDespachado :
                                  ((item.status == "ENTREGUE")   ? styles.viewEntregue   : styles.viewRecusado)))}>
                                  #{item.id} - PEDIDO { item.item }: { item.quantidade } un.
                      </Text>
                  </Animated.View>
              );
          }
          else
          {
              return(
                  <View key = { key }>
                      <Text style={(item.status == "PENDENTE")   ? styles.viewPendente   : 
                                  ((item.status == "ATENDIDO")   ? styles.viewAtendido   : 
                                  ((item.status == "DESPACHADO") ? styles.viewDespachado :
                                  ((item.status == "ENTREGUE")   ? styles.viewEntregue   : styles.viewRecusado)))}
                                  onPress={this.receberPedido.bind(this, item)}>
                                  #{item.id} - PEDIDO { item.item }: { item.quantidade } un.
                      </Text>
                  </View>
              );
          }
        }
    });

    return (
      <ScrollView style={styles.container}>
        

        <View style={styles.toolbar}>
          <View style={styles.toolbarRow}>
            <Text style={styles.toolbarTitle}>QUICK MENU</Text>
            <View style={styles.toolbarButton}>
              <Switch
                value={this.state.isEnabled}
                onValueChange={(val) => this.toggleBluetooth(val)}
              />
            </View>
          </View>
          <View style={styles.toolbarRow}>
            <Text style={styles.toolbarSubTitle}>{this.state.nomeCliente} - Mesa {this.state.mesa}</Text>
          </View>
        </View>

        <View>
          <Text style={styles.header}>INFORMAÇÕES DO CLIENTE</Text>
          <View style={{padding: 15}}>
            <Text>Mesa</Text>
            <Picker selectedValue={this.state.mesa} style={styles.picker}
              onValueChange={(value) => this.setState({mesa: value})}>
              <Picker.Item label="Mesa 01" value="1" style={styles.pickerItem} />
              <Picker.Item label="Mesa 02" value="2" style={styles.pickerItem} />
              <Picker.Item label="Mesa 03" value="3" style={styles.pickerItem} />
              <Picker.Item label="Mesa 04" value="4" style={styles.pickerItem} />
              <Picker.Item label="Mesa 05" value="5" style={styles.pickerItem} />
              <Picker.Item label="Mesa 06" value="6" style={styles.pickerItem} />
              <Picker.Item label="Mesa 07" value="7" style={styles.pickerItem} />
              <Picker.Item label="Mesa 08" value="8" style={styles.pickerItem} />
              <Picker.Item label="Mesa 09" value="9" style={styles.pickerItem} />
              <Picker.Item label="Mesa 10" value="10" style={styles.pickerItem} />
              <Picker.Item label="Mesa 11" value="11" style={styles.pickerItem} />
              <Picker.Item label="Mesa 12" value="12" style={styles.pickerItem} />
              <Picker.Item label="Mesa 13" value="13" style={styles.pickerItem} />
              <Picker.Item label="Mesa 14" value="14" style={styles.pickerItem} />
              <Picker.Item label="Mesa 15" value="15" style={styles.pickerItem} />
              <Picker.Item label="Mesa 16" value="16" style={styles.pickerItem} />
              <Picker.Item label="Mesa 17" value="17" style={styles.pickerItem} />
              <Picker.Item label="Mesa 18" value="18" style={styles.pickerItem} />
              <Picker.Item label="Mesa 19" value="19" style={styles.pickerItem} />
              <Picker.Item label="Mesa 20" value="20" style={styles.pickerItem} />
              <Picker.Item label="Mesa 21" value="21" style={styles.pickerItem} />
              <Picker.Item label="Mesa 22" value="22" style={styles.pickerItem} />
              <Picker.Item label="Mesa 23" value="23" style={styles.pickerItem} />
              <Picker.Item label="Mesa 24" value="24" style={styles.pickerItem} />
              <Picker.Item label="Mesa 25" value="25" style={styles.pickerItem} />
              <Picker.Item label="Mesa 26" value="26" style={styles.pickerItem} />
              <Picker.Item label="Mesa 27" value="27" style={styles.pickerItem} />
            </Picker>
            <Text>Cliente:</Text>
            <TextInput style={styles.input}
                onChangeText={(nomeCliente) => this.setState({nomeCliente})}
                value={this.state.nomeCliente} />
          </View>
        </View>
          
        <TouchableOpacity
          style={styles.customBtn}
          onPress={this.discoverAvailableDevices.bind(this)}
        >
          <Text style={styles.customBtnText}>Procurar por Dispositivos</Text>
        </TouchableOpacity>

        <FlatList
          style={{flex:1}}
          data={this.state.devices}
          keyExtractor={item => item.id}
          renderItem={(item) => this._renderItem(item)}
        />

        <View>
          <Text style={styles.header}>NOVO PEDIDO</Text>
          <View style={{padding: 15}}>
            <Text>Item</Text>
            <Picker selectedValue={this.state.item} style={styles.picker}
              onValueChange={(itemValue, itemIndex) => this.setState({item: itemValue})}>
              <Picker.Item label="Menu" value="" style={styles.pickerItem} />
              <Picker.Item label="Coxinha (R$ 3,50)" value="Coxinha" style={styles.pickerItem}/>
              <Picker.Item label="Cigarrete (R$ 3,00)" value="Cigarrete" style={styles.pickerItem} />
              <Picker.Item label="Café (R$ 0,50)" value="Cafe" style={styles.pickerItem} />
            </Picker>

            <Text>Quantidade</Text>
            <NumericInput valueType="integer" minValue={1} maxValue={100} step={1} 
              initValue={this.state.quantidade}
              value={this.state.quantidade}
              valueType='integer'
              onChange={quantidade => this.setState({quantidade})} />        
        
            <TouchableOpacity 
              style={styles.customBtnMargin}
              onPress={this.novoPedido.bind(this)}>
                <Icon style={styles.iconStyle} type='material-community' name='plus-circle' color='#52726f'/>
                <Text style={styles.customBtnText}>NOVO PEDIDO</Text>
            </TouchableOpacity>
          </View>
        </View>

        <ScrollView>
          <Text style={styles.header}>PEDIDOS</Text>
          <View>
            { newArray }
          </View>
        </ScrollView>
      </ScrollView >
    );
  }
}

const styles = StyleSheet.create({
  picker: {
    borderWidth: 1,
    borderColor: '#000'
  },
  pickerItem: {
    textAlign: 'center',
    backgroundColor: '#f2f2f2',
    borderBottomWidth: 1,
    borderBottomColor: '#EAEAEA'
  },
  container: {
    flex: 1,
    backgroundColor: '#f7f7f7'
  },
  input: {
    borderBottomWidth: 1,
    borderBottomColor: '#c1c1c1'
  },
  toolbar:{
    paddingTop: 30,
    paddingBottom: 30,
    flexDirection:'column',
  },
  toolbarRow:{
    flexDirection:'row'
  },
  toolbarButton:{
    width: 50,
    marginLeft: -75,
    marginRight: 25,
    marginTop: 8,
  },
  toolbarTitle:{
    textAlign:'center',
    fontWeight:'bold',
    fontSize: 20,
    flex:1,
    marginTop:6
  },
  toolbarSubTitle: {
    textAlign:'center',
    fontSize: 14,
    flex: 1
  },
  deviceName: {
    fontSize: 17,
    color: "#52726f",
    textAlign: 'center'
  },
  deviceNameWrap: {
    padding: 10,
    backgroundColor: '#f2f2f2',
    borderBottomWidth: 1,
    borderBottomColor: '#EAEAEA'
  },
  customBtn: {
    backgroundColor: '#EAEAEA',
    paddingBottom: 5,
    paddingTop: 5,
  },
  customBtnMargin: {
    backgroundColor: '#EAEAEA',
    paddingBottom: 5,
    paddingTop: 5,
    marginTop: 10
  },
  customBtnText: {
    color: '#52726f',
    textAlign: 'center',
  },
  header: {
    fontSize: 16,
    fontWeight: 'bold',
    textAlign: 'center',
    backgroundColor: '#EAEAEA',
    color: '#52726f',
    paddingTop: 10,
    paddingBottom: 10
  },
  viewPendente: {
    textAlign: 'center',
    backgroundColor: '#ffea51',
    padding: 10,
    borderBottomWidth: 1,
    borderBottomColor: '#f7f7f7'
  },
  viewRecusado: {
    textAlign: 'center',
    backgroundColor: '#9c72ff',
    padding: 10,
    borderBottomWidth: 1,
    borderBottomColor: '#f7f7f7'
  },
  viewAtendido: {
    textAlign: 'center',
    backgroundColor: '#a2ff51',
    padding: 10,
    borderBottomWidth: 1,
    borderBottomColor: '#f7f7f7'
  },
  viewEntregue: {
    textAlign: 'center',
    backgroundColor: '#edffe5',
    padding: 10,
    borderBottomWidth: 1,
    borderBottomColor: '#f7f7f7'
  },
  viewDespachado: {
    textAlign: 'center',
    backgroundColor: '#51d0ff',
    padding: 10,
    borderBottomWidth: 1,
    borderBottomColor: '#f7f7f7'
  },
  pedido: {
    padding: 10,
    borderBottomWidth: 1,
    borderBottomColor: '#f7f7f7'
  },
  iconStyle: {
    color: '#52726f'
  }
});