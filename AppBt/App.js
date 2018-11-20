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

  /*static propTypes = {
    nome: PropTypes.string.isRequired,
    quantidade: PropTypes.number.isRequired,
    status: PropTypes.string.isRequired
  }*/

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
      nomeCliente: "",
      message: "",
      item: "",
      quantidade: 1,
      pedidos: [],
      disabled: false,
      id: -1,
      status: ""
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
            //Alert.alert('Dados recebidos', `DATA FROM BT: ${data.data}`);
            this.handleReceivedMessage(data);
         });
    });
  }

  connect (device) {
    this.setState({ connecting: true })
    BluetoothSerial.connect(device.id)
    /*BluetoothSerial.connect('00:21:13:01:63:04')*/
    .then((res) => {
      console.log(`Connected to device ${device.name}`);
      this.setState({ connected: true })
      ToastAndroid.show(`Connected to device ${device.name}`, ToastAndroid.SHORT);
      var msg = '{{CLIENTE}},' + "1" + ",Cliente 01";
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
      var msg = '{{PEDIDO}},' + this.state.item + ',' + this.state.quantidade;
      this.sendMessage(msg);
    } else {
      Alert.alert('Pedido não enviado', 'Selecione um item');
    }
  }

  addPedido () {
    this.animatedValue.setValue(0)

    let newPedido = { id: this.state.id, item: this.state.item, quantidade: this.state.quantidade, status: this.state.status }

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

  handleReceivedMessage(data) {
    var msg = data.data;
    var comando = msg.substring(0, 11);

    if(comando === "{{0BUZZER}}") {
      var indexFim = msg.indexOf(',', 12);
      this.state.id = parseInt(msg.substring(12, indexFim));
      var indexFimStatus = msg.indexOf('\n', indexFim);
      this.state.status = msg.substring(indexFim + 1, indexFimStatus);

      //Alert.alert('Alterou ', data.data);
      this.addPedido();
    }
  }

  sendMessage (msg) {
    //if(this.state.connected) {
      BluetoothSerial.write(msg)
      .then((res) => {
        this.setState({ connected: true })
      })
      .catch((err) => console.log(err.message))
    //}
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
        if(( key ) == this.index)
        {
            return(
                <Animated.View key = { key } style = {[ styles.viewHolder, { opacity: this.animatedValue, transform: [{ translateY: animationValue }] }]}>
                    <Text style={styles.pedido}>Pedido { item.item }: { item.quantidade } un.</Text>
                </Animated.View>
            );
        }
        else
        {
            return(
                <View key = { key } style = { styles.viewHolder }>
                    <Text style={styles.pedido}>Pedido { item.item }: { item.quantidade } un.</Text>
                </View>
            );
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
            <Text style={styles.toolbarSubTitle}>Cliente - Mesa 01</Text>
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
  viewHolder: {
    textAlign: 'center',
    backgroundColor: '#c9e8e4',
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