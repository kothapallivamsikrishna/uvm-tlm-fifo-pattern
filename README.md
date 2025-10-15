# UVM TLM FIFO Communication Pattern

This repository provides a focused, self-contained example of using a **`uvm_tlm_fifo`** to facilitate transaction-level communication between UVM components. This pattern is fundamental to building modular, reusable, and abstract verification environments.

---

### Project Overview

Instead of connecting components with physical wires (`interface`), Transaction-Level Modeling (TLM) allows components to communicate by calling methods on each other (e.g., `put`, `get`). The `uvm_tlm_fifo` is a built-in UVM class that acts as a simple storage buffer, enabling two components to exchange transactions without being directly connected.



This project illustrates how:
1.  A **`sender`** component generates transactions and uses a `uvm_blocking_put_port` to send them.
2.  A **`receiver`** component uses a `uvm_blocking_get_port` to retrieve transactions.
3.  A **`uvm_tlm_fifo`** is instantiated in a parent component (`test`) to act as the communication channel.
4.  The `connect_phase` is used to wire the ports of the `sender` and `receiver` to the exports of the FIFO, establishing the data path.

---

### File Structure

-   `tlm_fifo_test.sv`: A single SystemVerilog file containing the complete UVM code, including the `sender` and `receiver` components and the top-level test that connects them.

---

### Key Concepts Illustrated

-   **Transaction-Level Modeling (TLM)**: The core concept of abstracting communication between components using method calls instead of pin wiggling.
-   **`uvm_tlm_fifo`**: A pre-built UVM component that provides a transactional FIFO buffer, simplifying the connection between a producer and a consumer.
-   **TLM Ports and Exports**: The standard mechanism for TLM connections. The `sender` has a `put_port` (it wants to initiate a `put`), the `receiver` has a `get_port` (it wants to initiate a `get`), and the FIFO provides `put_export` and `get_export` to implement those methods.
-   **`connect_phase`**: The UVM phase where TLM connections between components are established.

---

### How to Run

1.  Compile `tlm_fifo_test.sv` using a simulator that supports SystemVerilog and UVM.
2.  Set `tb` as the top-level module for simulation.
3.  Execute the simulation. The log will show the `sender` putting data items into the FIFO and the `receiver` getting them out, demonstrating the decoupled, buffered communication.
