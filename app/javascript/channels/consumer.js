import { createConsumer } from "../solid_cable.js"
// export default createConsumer()

const host = window.location.origin.replace(/^http/, "ws");
const consumer = createConsumer(`${host}/cable`);

export default consumer;
