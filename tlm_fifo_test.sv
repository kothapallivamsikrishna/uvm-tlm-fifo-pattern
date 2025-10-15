`include "uvm_macros.svh"
import uvm_pkg::*;

class sender extends uvm_component;
    `uvm_component_utils(sender)

  logic [3:0] data;
  uvm_blocking_put_port #(logic [3:0]) send;

  function new(input string path = "sender", uvm_component parent = null);
    super.new(path,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    send = new("send", this);
  endfunction

    virtual task run_phase(uvm_phase phase);
      phase.raise_objection(this);
      for(int i = 0 ; i < 15; i++)
        begin
          data = $urandom_range(0, 15);
          `uvm_info("SENDER", $sformatf("Putting data: %0d", data), UVM_MEDIUM);
          send.put(data);
          #20;
        end
      phase.drop_objection(this);
    endtask
endclass
///////////////////////////////////////////////////////////////

class receiver extends uvm_component;
    `uvm_component_utils(receiver)

  logic [3:0] datar;
  uvm_blocking_get_port #(logic [3:0]) recv;

  function new(input string path = "receiver", uvm_component parent = null);
    super.new(path,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    recv = new("recv", this);
  endfunction

    virtual task run_phase(uvm_phase phase);
      forever begin
        #40; // Wait longer to show FIFO buffering
        recv.get(datar);
        `uvm_info("RECEIVER", $sformatf("Got data: %0d", datar), UVM_MEDIUM);
      end
    endtask
endclass
////////////////////////////////////////////////////////////////////////

class test extends uvm_test;
    `uvm_component_utils(test)

  uvm_tlm_fifo #(logic [3:0]) fifo;
  sender s;
  receiver r;

  function new(input string path = "test", uvm_component parent = null);
    super.new(path,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Create the TLM FIFO with a size of 10
    fifo = new("fifo", this, 10);
    s = sender::type_id::create("s", this);
    r = receiver::type_id::create("r", this);
  endfunction

    virtual function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      // Connect the sender's put port to the FIFO's put export
      s.send.connect(fifo.put_export);
      // Connect the receiver's get port to the FIFO's get export
      r.recv.connect(fifo.get_export);
    endfunction

      virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        #400; // Allow time for all transactions to complete
        phase.drop_objection(this);
      endtask
endclass
////////////////////////////////////////////////////////////////////////////

module tb;
  initial begin
    run_test("test");
  end
endmodule
