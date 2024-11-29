const INTERNAL = {
  message_types: {
    welcome: 'welcome',
    disconnect: 'disconnect',
    ping: 'ping',
    confirmation: 'confirm_subscription',
    rejection: 'reject_subscription'
  },
  disconnect_reasons: {
    unauthorized: 'unauthorized',
    invalid_request: 'invalid_request',
    server_restart: 'server_restart'
  },
  default_mount_path: '/cable',
  protocols: ['actioncable-v1-json', 'actioncable-unsupported']
};

const { message_types, protocols, disconnect_reasons } = INTERNAL;

class Connection {
  constructor(consumer) {
    this.consumer = consumer;
    this.open();
  }

  send(data) {
    if (this.isOpen()) {
      this.webSocket.send(JSON.stringify(data));
      return true;
    } else {
      return false;
    }
  }

  open() {
    if (this.isActive()) {
      console.log('Attempted to open WebSocket, but existing socket is ' + this.getState());
      return false;
    } else {
      console.log('Opening WebSocket, current state is ' + this.getState());
      this.webSocket = new WebSocket(this.consumer.url, protocols);
      this.installEventHandlers();
      return true;
    }
  }

  close({ allowReconnect } = { allowReconnect: true }) {
    if (!allowReconnect) {
      this.consumer.closedPermanently = true;
    }
    if (this.isActive()) {
      return this.webSocket.close();
    }
  }

  isOpen() {
    return this.isState('open');
  }

  isActive() {
    return this.isState('open', 'connecting');
  }

  isProtocolSupported() {
    return protocols.includes(this.getProtocol());
  }

  isState(...states) {
    return states.includes(this.getState());
  }

  getState() {
    if (this.webSocket) {
      for (let state in WebSocket) {
        if (WebSocket[state] === this.webSocket.readyState) {
          return state.toLowerCase();
        }
      }
    }
    return null;
  }

  getProtocol() {
    if (this.webSocket) {
      return this.webSocket.protocol;
    }
  }

  installEventHandlers() {
    for (let eventName of ['open', 'close', 'error', 'message']) {
      this.webSocket[`on${eventName}`] = (event) => {
        try {
          if (this.isProtocolSupported()) {
            this.consumer[`on${eventName}`](event);
          }
        } catch (error) {
          console.error(error);
        }
      };
    }
  }
}

class Consumer {
  constructor(url) {
    this.url = url;
    this.subscriptions = new Subscriptions(this);
    this.connection = new Connection(this);
    this.closedPermanently = false;
  }

  send(data) {
    return this.connection.send(data);
  }

  connect() {
    return this.connection.open();
  }

  disconnect() {
    return this.connection.close({ allowReconnect: false });
  }

  ensureActiveConnection() {
    if (!this.connection.isActive()) {
      return this.connection.open();
    }
  }

  onopen(event) {
    this.subscriptions.reload();
  }

  onclose(event) {
    if (!this.closedPermanently) {
      setTimeout(() => this.connect(), 3000);
    }
  }

  onerror(event) {
    console.error('WebSocket error:', event);
  }

  onmessage(event) {
    const data = JSON.parse(event.data);
    switch (data.type) {
      case message_types.welcome:
        this.subscriptions.reload();
        break;
      case message_types.ping:
        this.connection.send({ type: 'pong' });
        break;
      case message_types.confirmation:
        this.subscriptions.notify(data.identifier, 'connected');
        break;
      case message_types.rejection:
        this.subscriptions.reject(data.identifier);
        break;
      default:
        this.subscriptions.notify(data.identifier, 'received', data.message);
    }
  }
}

class Subscriptions {
  constructor(consumer) {
    this.consumer = consumer;
    this.subscriptions = {};
  }

  create(channelName, mixin) {
    const channel = channelName;
    const params = typeof channel === 'object' ? channel : { channel };
    const identifier = JSON.stringify(params);
    return this.subscriptions[identifier] || (this.subscriptions[identifier] = new Subscription(this.consumer, params, mixin));
  }

  forget(identifier) {
    delete this.subscriptions[identifier];
  }

  reload() {
    for (let identifier in this.subscriptions) {
      this.subscriptions[identifier].rejoin();
    }
  }

  reject(identifier) {
    const subscription = this.subscriptions[identifier];
    if (subscription) {
      subscription.reject();
    }
  }

  notify(identifier, type, message) {
    const subscription = this.subscriptions[identifier];
    if (subscription) {
      switch (type) {
        case 'connected':
          subscription.connected();
          break;
        case 'rejected':
          subscription.rejected();
          break;
        case 'received':
          subscription.received(message);
          break;
        case 'disconnected':
          subscription.disconnected();
          break;
      }
    }
  }
}

class Subscription {
  constructor(consumer, params = {}, mixin = {}) {
    this.consumer = consumer;
    this.identifier = JSON.stringify(params);
    Object.assign(this, mixin);
    this.subscriptionData = { ...params };
  }

  perform(action, data = {}) {
    const dataToSend = { ...data, action };
    return this.send(dataToSend);
  }

  send(data) {
    return this.consumer.send({
      command: 'message',
      identifier: this.identifier,
      data: JSON.stringify(data)
    });
  }

  connected() {
    // Override in subclass
  }

  disconnected() {
    // Override in subclass
  }

  rejected() {
    // Override in subclass
  }

  received(data) {
    // Override in subclass
  }

  rejoin() {
    this.consumer.send({
      command: 'subscribe',
      identifier: this.identifier
    });
  }

  reject() {
    this.consumer.subscriptions.forget(this.identifier);
  }
}

export function createConsumer(url = getDefaultUrl()) {
  return new Consumer(url);
}

function getDefaultUrl() {
  const element = document.head.querySelector('meta[name="solid-cable-url"]');
  return element?.content || `${window.location.protocol === 'https:' ? 'wss:' : 'ws:'}//${window.location.host}${INTERNAL.default_mount_path}`;
}

export { Consumer, INTERNAL };
