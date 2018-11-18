import React, { Component } from 'react';
import {
  Platform,
  StyleSheet,
  Text,
  View,
  Button,
  FlatList,
  Switch,
  TouchableOpacity,
  ToastAndroid,
  TextInput
} from 'react-native';
var _ = require('lodash');
import BluetoothSerial from 'react-native-bluetooth-serial'

export default class App extends Component<{}> {
  
  constructor (props) {
    super(props)
    this.state = {
      isEnabled: false,
      discovering: false,
      devices: [],
      unpairedDevices: [],
      connected: false,
      message: ""
    }
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

  }

  connect (device) {
    this.setState({ connecting: true })
    BluetoothSerial.connect(device.id)
    /*BluetoothSerial.connect('00:21:13:01:63:04')*/
    .then((res) => {
      console.log(`Connected to device ${device.name}`);
      
      ToastAndroid.show(`Connected to device ${device.name}`, ToastAndroid.SHORT);
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

  toggleSwitch(){
    BluetoothSerial.write("T")
    .then((res) => {
      console.log(res);
      console.log('Successfuly wrote to device')
      this.setState({ connected: true })
    })
    .catch((err) => console.log(err.message))
  }

  sendMessage() {
    BluetoothSerial.write(this.state.message)
    .then((res) => {
      this.setState({ connected: true })
    })
    .catch((err) => console.log(err.message))
  }

  _renderItem(item){

    return(
        <TouchableOpacity onPress={() => this.connect(item.item)}>
          <View style={styles.deviceNameWrap}>
            <Text style={styles.deviceName}>{ item.item.name ? item.item.name : item.item.id }</Text>
          </View>
        </TouchableOpacity>
    )
  }

  render() {

    return (
      <View style={styles.container}>
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
            <Text style={styles.toolbarSubTitle}>Dispositivos Bluetooth</Text>
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
            <TextInput
              placeholder="Enviar mensagem"
              onChangeText={
                (message) => {
                  this.setState({message})
                  this.sendMessage()
                }
              }
            />
          </View>

          {/*
          <Button
            onPress={this.toggleSwitch.bind(this)}
            title="Switch(On/Off)"
            color="#EAEAEA"
          />*/}

      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f7f7f7'
  },
  toolbar:{
    paddingTop:30,
    paddingBottom:30,
    flexDirection:'column'
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
    color: "black"
  },
  deviceNameWrap: {
    margin: 10,
    borderBottomWidth:1
  },
  customBtn: {
    backgroundColor: '#EAEAEA',
    paddingBottom: 5,
    paddingTop: 5
  },
  customBtnText: {
    color: '#52726f',
    textAlign: 'center',
  }
});