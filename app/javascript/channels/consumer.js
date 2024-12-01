import { createConsumer } from "solid_cable"
// export default createConsumer()

const host = window.location.origin.replace(/^https/, "wss");
const consumer = createConsumer(`${host}/cable`);

export default consumer;
