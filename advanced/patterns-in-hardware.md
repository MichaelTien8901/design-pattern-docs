---
layout: default
title: "Patterns in Hardware Design"
parent: "Advanced Patterns"
nav_order: 24
---

# Patterns in Practice: Hardware Design

Design patterns aren't limited to software. The same fundamental challenges — decoupling, flow control, error handling, resource arbitration — appear in hardware, and engineers solve them with structurally identical patterns. The key difference: hardware operates at nanosecond granularity with deterministic timing, spatial parallelism, and physical enforcement guarantees.

## Bus Protocols & Interconnects

For each entry, the hardware concept maps to specific pattern(s), with an explanation of how the pattern manifests and key differences from the software version.

### PCIe Data Poisoning — Poison Pill + Null Object + Chain of Responsibility

- When a component detects an uncorrectable error (e.g., ECC failure reading memory), it sets the EP (Error Poisoned) bit in the TLP header
- The poisoned TLP is **forwarded through the fabric**, not dropped. Switches ignore the poison bit.
- Only the final endpoint inspects it — logs via AER, discards payload
- **Poison Pill**: marked as sentinel "this is invalid data"
- **Null Object**: same structure as valid packet, but semantically void
- **Chain of Responsibility**: propagates through switch chain until endpoint handles it
- **Key difference from software**: In software, Poison Pill typically terminates a consumer. In PCIe, it's advisory — endpoint may log as Non-Fatal and continue operating.

### PCIe Credit-Based Flow Control — Token Bucket + Back-Pressure

- Receivers advertise credits (buffer slots): 1 data credit = 16 bytes, 1 header credit = 1 TLP
- Credits tracked independently for Posted (P), Non-Posted (NP), and Completion (CPL) traffic
- Transmitter cannot send without confirming sufficient credits
- Credits returned via periodic UpdateFC DLLPs
- **Key difference**: Software token buckets rate-limit; PCIe credits are about buffer capacity. Three independent flow control domains (P/NP/CPL) is more granular than most software.

### PCIe TLP Routing — Strategy + Router

- Three routing methods: address-based (memory/IO), ID-based (Bus/Device/Function), implicit (upstream/downstream)
- Switch decodes routing type from TLP header and forwards accordingly
- Strategy encoded in packet header by protocol spec, not selected at runtime

### AXI Valid/Ready Handshake — Producer-Consumer + Back-Pressure

- Source asserts VALID when data available; sink asserts READY when it can accept
- Transfer occurs only when both VALID && READY on same clock edge
- **Critical rule**: Source must NOT wait for READY before asserting VALID (deadlock prevention)
- 5 separate channels (Write Addr, Write Data, Write Response, Read Addr, Read Data) = Command-Query Separation
- **Key difference**: The no-wait rule on VALID has no software equivalent — it's a hardware-specific deadlock prevention constraint.

### CXL Memory Pooling — Object Pool + Facade + Proxy

- CXL 2.0: switches enable multiple hosts to share a pool of memory devices
- **Object Pool**: hosts dynamically allocate/deallocate memory segments from shared pool
- **Facade**: unified "coherent memory access" regardless of location (host DRAM, device HBM, pooled CXL)
- **Proxy**: CXL.cache lets devices coherently cache host memory; host coherency manager ensures consistency

## Chip Architecture

### CPU Pipeline — Pipes and Filters

- Classic RISC 5-stage: Fetch → Decode → Execute → Memory → Writeback
- Each stage is a filter; pipeline registers are pipes
- Multiple instructions in-flight simultaneously (spatial parallelism)
- **Key difference from software**: Hardware hazards (data, control, structural) require forwarding, stalling, and speculation. Each stage executes in exactly one clock cycle. Software filters have variable processing time.

### Cache Coherence (MESI/MOESI) — State Pattern + Observer + Mediator

- Each cache line has states: Modified, Exclusive, Shared, Invalid (+ Owned in MOESI)
- **State Pattern**: transitions triggered by local CPU ops and bus snoop events
- **Observer (Pub-Sub)**: snoop bus broadcasts writes; all cores monitoring that address update state
- **Mediator**: directory-based coherence (NUMA) uses central directory mediating between cores
- Operates at nanosecond granularity with dedicated snoop filter hardware

### Memory Hierarchy — Cache + Proxy + Chain of Responsibility

- L1 → L2 → L3 → DRAM → Disk: faster/smaller caches in front of slower/larger
- Each level acts as transparent proxy for the level below
- On miss, request propagates down the chain until satisfied
- **The software "cache pattern" is literally named after this hardware concept**

### Interrupt Handling — Observer + Chain of Responsibility + Command

- Devices assert interrupt lines; interrupt controller (APIC, GIC) prioritizes and delivers to CPU
- CPU looks up IDT (Interrupt Descriptor Table), dispatches to registered handler
- Shared interrupt lines: handlers form a chain, each checking "is this for me?"
- **Key difference**: truly asynchronous and preemptive — forcibly suspends current execution

### DMA — Command + Future

- CPU programs DMA descriptor (source, dest, size, direction) — a serialized command object
- DMA engine executes autonomously; signals completion via interrupt (async result / Future)
- Scatter-Gather DMA = linked list of descriptors = Composite Command

### IOMMU/MMU — Proxy + Adapter + Decorator

- MMU translates CPU virtual → physical addresses via page tables
- IOMMU does same for device DMA — intercepts and translates device addresses
- **Proxy**: transparent interposition between requestor and memory
- **Adapter**: resolves address space mismatch in virtualized environments
- **Decorator**: access control (R/W/X permissions) layered on translation

### Register Renaming — Flyweight

- Physical registers are shared intrinsic state
- Logical register names (R3, R7) are extrinsic keys
- Register rename table (RAT) dynamically maps logical → physical
- Eliminates false dependencies (WAW/WAR hazards) — dynamic Flyweight allocation

### Clock Domain Crossing — Adapter + Bridge + Producer-Consumer

- Two-FF synchronizer for single-bit signals (metastability settling)
- Async FIFO for multi-bit: dual-port RAM with Gray-coded pointers crossing domains
- **Adapter**: translates signals between clock domains
- **Bridge**: decouples domains so they vary independently
- **Producer-Consumer**: async FIFO is a bounded buffer between clock domains

## Digital Logic Design Patterns

### Finite State Machines — State Pattern (1:1 Mapping)

- Moore (output = state) and Mealy (output = state + input) machines
- One transition per clock cycle via combinational next-state logic + registers
- Exhaustively verified for all state/input combinations (rarely achieved in software)

### FIFO Buffers — Queue / Producer-Consumer

- Circular buffer with read/write pointers
- Hardware adds: `full`, `empty`, `almost_full`, `almost_empty` signals
- Ubiquitous: between pipeline stages, at clock domain crossings, in network interfaces

### Arbiters — Mediator

- Resolves contention for shared resources (bus, memory port, crossbar)
- Types: Fixed Priority, Round-Robin, Weighted Round-Robin, Lottery
- Single-cycle decisions via combinational logic (priority encoders, rotating masks)

### MUX/DEMUX — Strategy / Router

- MUX: select signal chooses which input to route to output (Strategy selection)
- DEMUX: routes single input to one of N outputs (Router / dispatch)
- Essentially a hardware switch statement

### Parameterized Modules — Generics / Templates

- Verilog `parameter` / VHDL `generic` for configurable instantiation
- Example: `module fifo #(parameter DATA_WIDTH=8, DEPTH=16)`
- Resolved at synthesis time (like C++ templates) — produces physically distinct hardware

### IP Core Reuse — Component + Template Method

- Pre-designed, pre-verified blocks (UART, PCIe controller, DDR PHY)
- Standardized interfaces (AXI, APB) for plug-and-play integration
- Parameterizable with configurable hooks (interrupts, DMA callbacks)

## Hardware Security

### Hardware Root of Trust — Singleton (Immutable)

- Immutable component: ROM, fused keys, tamper-resistant module
- Contains cryptographic keys and verification logic for entire trust chain
- Examples: Intel CSME, AMD PSP, ARM TrustZone, Apple Secure Enclave, Google Titan
- **Key difference**: software singletons can be patched or mocked. HRoT is physically immutable.

### Secure Boot — Chain of Responsibility + Builder

- Sequential verification: HRoT → bootloader stage 0 → stage 1 → kernel → drivers
- Each stage cryptographically authenticates the next before transferring control
- Failure at any stage halts the entire system (much more drastic than software CoR)

### Hardware Isolation (TrustZone/SGX) — Bulkhead / Sandbox

- ARM TrustZone: two execution worlds (Secure, Normal) enforced by hardware
- Intel SGX: hardware-encrypted memory enclaves
- Bus fabric physically refuses transactions from wrong security domain
- **Key difference**: software sandboxes rely on OS enforcement (bypassable). Hardware isolation is physical.

### Side-Channel Mitigations — Constant-Time + Decorator + Bulkhead

- Constant-time execution: crypto ops take same cycles regardless of input
- Power noise injection: dummy operations mask power signatures (Decorator)
- Cache partitioning: separate cache ways per security domain (Bulkhead)

## Quick Reference

| Hardware Concept | Pattern(s) | Key Insight |
|-----------------|-----------|-------------|
| PCIe Data Poisoning | Poison Pill, Null Object, CoR | Corrupted data forwarded, not dropped; endpoint decides |
| PCIe Credit Flow | Token Bucket, Back-Pressure | Typed credits (P/NP/CPL) more granular than software |
| AXI Handshake | Producer-Consumer, Back-Pressure | VALID must not wait for READY (no software equivalent) |
| CXL Memory Pool | Object Pool, Facade, Proxy | Hardware memory pool with coherency |
| CPU Pipeline | Pipes and Filters | Spatial parallelism; hazards unique to hardware |
| Cache Coherence | State, Observer, Mediator | Snoop bus = pub-sub; directory = mediator |
| Memory Hierarchy | Cache, Proxy, CoR | Software "cache pattern" named after this |
| Interrupts | Observer, CoR, Command | Truly async/preemptive unlike software |
| DMA | Command, Future | Descriptor = command; completion = async result |
| MMU/IOMMU | Proxy, Adapter, Decorator | Transparent translation + access control |
| Register Renaming | Flyweight | Physical regs = shared state; logical = extrinsic key |
| Clock Domain Crossing | Adapter, Bridge | Async FIFO decouples independent domains |
| FSM | State Pattern | 1:1 mapping; one cycle per transition |
| Arbiters | Mediator | Single-cycle via combinational logic |
| Parameterized Modules | Generics/Templates | Resolved at synthesis time |
| Root of Trust | Singleton (immutable) | Physically immutable, unlike software |
| Secure Boot | CoR, Builder | Failure halts entire system |
| TrustZone/SGX | Bulkhead, Sandbox | Bus fabric enforces isolation |

## References

| Topic | Resource | Link |
|-------|----------|------|
| PCIe Data Poisoning | OCP Poison White Paper | [opencompute.org](https://www.opencompute.org/documents/using-poison-to-contain-and-recover-from-uncorrected-errors-pdf) |
| PCIe Data Poisoning | Intel Error Reporting | [intel.com](https://www.intel.com/content/www/us/en/docs/programmable/683647/18-0/error-reporting-and-data-poisoning.html) |
| PCIe Flow Control | Intel Credit Handling | [intel.com](https://www.intel.com/content/www/us/en/docs/programmable/790711/24-1-2-0-0/flow-control-credit-handling.html) |
| PCIe AER | Linux AER HOWTO | [kernel.org](https://docs.kernel.org/PCI/pcieaer-howto.html) |
| AXI/AMBA | ARM AXI Specification | [developer.arm.com](https://developer.arm.com/documentation/ihi0022/latest/) |
| AXI Handshake | VHDLwhiz AXI Guide | [vhdlwhiz.com](https://vhdlwhiz.com/how-the-axi-style-ready-valid-handshake-works/) |
| CXL | CXL Consortium | [computeexpresslink.org](https://www.computeexpresslink.org/) |
| CXL | Rambus CXL Overview | [rambus.com](https://www.rambus.com/blogs/compute-express-link/) |
| CPU Pipeline | Berkeley Pipeline Pattern | [berkeley.edu](https://patterns.eecs.berkeley.edu/?page_id=542) |
| Cache Coherence | MESI Protocol | [Wikipedia](https://en.wikipedia.org/wiki/MESI_protocol) |
| Cache Coherence | Coherence Primer | [Wikipedia](https://en.wikipedia.org/wiki/Cache_coherence) |
| Memory Hierarchy | Memory Hierarchy | [Wikipedia](https://en.wikipedia.org/wiki/Memory_hierarchy) |
| Interrupts | APIC | [Wikipedia](https://en.wikipedia.org/wiki/Advanced_Programmable_Interrupt_Controller) |
| DMA | DMA Overview | [Wikipedia](https://en.wikipedia.org/wiki/Direct_memory_access) |
| IOMMU | IOMMU Overview | [Wikipedia](https://en.wikipedia.org/wiki/Input%E2%80%93output_memory_management_unit) |
| Clock Domain Crossing | Verilog Pro CDC | [verilogpro.com](https://www.verilogpro.com/clock-domain-crossing-part-1/) |
| Arbiters | Arbiter Design Styles | [Paper (PDF)](https://abdullahyildiz.github.io/files/Arbiters-Design_Ideas_and_Coding_Styles.pdf) |
| NoC | Network on Chip | [Wikipedia](https://en.wikipedia.org/wiki/Network_on_a_chip) |
| Root of Trust | Rambus HRoT | [rambus.com](https://www.rambus.com/blogs/hardware-root-of-trust/) |
| Secure Boot | Cloudflare Secure Boot | [blog.cloudflare.com](https://blog.cloudflare.com/anchoring-trust-a-hardware-secure-boot-story/) |
| TrustZone | ARM TrustZone | [developer.arm.com](https://developer.arm.com/documentation/102418/latest/) |
| Rust RAII | Rust by Example | [doc.rust-lang.org](https://doc.rust-lang.org/rust-by-example/scope/raii.html) |
| ECC | ECC Memory | [Wikipedia](https://en.wikipedia.org/wiki/ECC_memory) |
| Watchdog | Watchdog Best Practices | [memfault.com](https://interrupt.memfault.com/blog/firmware-watchdog-best-practices) |
