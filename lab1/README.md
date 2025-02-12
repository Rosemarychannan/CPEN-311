[![Open in Codespaces](https://classroom.github.com/assets/launch-codespace-2972f46106e565e64193e422d61a12cf1da4916b45550586e14ef0a7c637dd04.svg)](https://classroom.github.com/open-in-codespaces?assignment_repo_id=16075138)
# Lab 1: Simple Datapath and Controller: Baccarat


## Contents

* [Introduction](#introduction)
  * [FPGA board](#fpga-board)
* [Baccarat](#baccarat)
* [Phase 1: Getting your environment ready](#phase-1-getting-your-environment-ready)
* [Phase 2: Warmup](#phase-2-warmup)
  * [Task 1: A seven\-segment LED driver](#task-1-a-seven-segment-led-driver)
* [Phase 3: Baccarat\!](#phase-3-baccarat)
  * [Task 2: Learn how to play Baccarat](#task-2-learn-how-to-play-baccarat)
  * [Task 3: Understand the overall functionality](#task-3-understand-the-overall-functionality-your-circuit-should-implement)
  * [Task 4: Understand the hardware components](#task-4-understand-the-components-of-our-circuit)
  * [Task 5: Baccarat code and testbenches](#task-5-baccarat-code-and-testbenches)
  * [Task 6: Verify your design on a DE1\-SoC board](#task-6-verify-your-design-on-a-de1-soc-board)
* [Simulation and Code Coverage with ModelSim](#simulation-and-code-coverage-with-modelsim)
  * [SSH Access](#ssh-access)
* [Deliverables and Evaluation](#deliverables-and-evaluation)
  * [Using GitHub](#using-github)
  * [Code coverage](#code-coverage)
  * [Post\-synthesis simulation](#post-synthesis-simulation)
  * [Marks Breakdown](#marks-breakdown)
* [Autograder Marking Process](#autograder-marking-process)
  * [Autograder Marks](#autograder-marks)


## Introduction

In this lab, you will become familiar with the software and hardware we will be using in the labs, and use the hardware and software to implement a simple digital datapath.

We will be using two pieces of software for most of this course: Quartus Prime, which is produced by Intel, and ModelSim, which is produced by Mentor Graphics. There are several versions of ModelSim available; we will be using one that is distributed with Quartus. You will need to download and install these programs (the free Lite version).

We strongly recommend that you start working on labs **early** — it always takes longer than you think, especially if you are not very good at debugging. This lab is relatively easy; future labs will be harder and will take longer.


### FPGA board

The labs in this course are designed to be completed using a DE1-SoC FPGA
board.  For some labs, it may be possible to use similar FPGA boards, but they
may lack essential features.  the DE0-CV board might work in a pinch, but it
does not have the hardened ARM processor system (aka `hps`) which is required
in CPEN391 and might be required in a later lab in this course.

If you have misplaced your board, it is possible to complete the lab and
receive marks for it without access to physical board. We still recommend that
you use your DE1-SoC if you have one — you will have a much more rewarding
experience.

Read the [Virtual DE1-SoC](de1-gui/README.md) document to learn how to simulate
and debug your code without a physical FPGA.  If you are demonstrating to a TA
for marks, you must use the post-synthesis netlist.  Note that simulating with
the Virtual DE1-SoC is extremely slow.
**To use the Virtual DE1-SoC, do not copy the files into your task folders! Instead, reference them using relative filenames, e.g.
`../de1-gui/de1_gui.sv`**

Be sure to read the [Deliverables and Evaluation](#deliverables-and-evaluation)
section to understand how we will mark your submission.


## Baccarat

The end result of this lab will be a Baccarat engine. Baccarat is a card game played in casinos around the world. Baccarat is for “high rollers” — James Bond is a fan of Baccarat (and, for some odd reason, martinis made with cheap vodka and tiny ice shards). Designing this Baccarat engine will help you understand how a simple datapath can be constructed and controlled by a state machine; this is the foundation of all large digital circuits.

It may be tempting to write a software-like specification and hope that the synthesis tools can synthesize the design to hardware. It is unlikely that this approach would be successful even for this simple design. In this lab, we will consider the circuit at the level of the hardware we want to build — to succeed in this course, you need to understand exactly what hardware you are building and exactly how this hardware works. This handout will take you through the steps needed to construct the circuit, starting from the basic blocks, and ending in a working circuit on your DE1-SoC (or DE0-CV) board.


## Phase 1: Getting your environment ready

Complete the design flow tutorial, distributed separately. This will ensure you have the correct versions of the design tools and that you can use them to program your FPGA board. There are no deliverables for this task.


## Phase 2: Warmup

To get you started quickly, in this Phase, you will create the simplest useful combinational circuit we can think of. It will also be a component in the Baccarat game that you will create in Phase 3.

You will design a combinational block with four inputs and seven outputs:

<p align="center"><img src="figures/7seg.png" width="50%" height="50%" title="7-segment display"></p>

In this phase, the four inputs will be connected to switches 3 to 0 on your board, and the seven outputs are connected to a single seven-segment display on your board.

The circuit operates as follows. The four inputs represent an unsigned, 4-bit binary number with a value between 0 and 15. Each number between 1 and 13 represents a specific card value in a deck of cards, as follows: Ace=1, number cards are represented as themselves, Jack=11, Queen=12, and King=13. An input of 0 represents “no card” and input values of 14 and 15 will not be used; for the purposes of this Phase, you should display a blank if they do occur.

The output is a set of values that will display the value of the card on the seven segment display:

<p align="center"><img src="figures/card-7seg.png" width="20%" height="20%" title="card values"></p>

Each segment in the display is controlled by one of the `HEX` output lines. Note that the lines driving the seven-segment display are active-low — that means that a 0 turns the segment **on** and a 1 turns the segment **off** (this is the opposite of what you might expect).

### Task 1: A seven-segment LED driver

Add your code to implement the Verilog stub in the `task1` folder. Create a project in Quartus, import the pin assignments, compile your design, download it to the board, and test your design. Remember to import the correct pin assignment file for the board you are using from the `settings` folder.

Write a module with unit tests for the LED driver in `tb_card7seg.sv`. Your testbech module will be named `tb_card7seg` and will have no ports. This means it will need to instantiate `card7seg.sv`, as well as and drive any clock(s) in the design using the Verilog delay syntax (`#`). Be sure that your testbench covers **all cases**, even those for which the display is blank. You may use waveforms or text output (such as `$display`, `$monitor`, or `$strobe`) to check whether your testbench works; we only care that it exercises the entire design under test.

Even though this particular module isn't very complex, we strongly recommend writing the testbench **before** you start implementing the block in Verilog. You should approach all modules this way; this will make your life **much** easier later when you are working on more complex designs. It will force you to go through the specification carefully and make sure you really understand it, and will avoid leaking hidden assumptions from your design into your tests. Plus, it's satisfying to finish your code and see that it passes all your tests!

Be sure to exhaustively test **both** the SystemVerilog RTL code you write and the post-synthesis netlist Verilog file produced by Quartus (see the Tutorial).

## Phase 3: Baccarat!

### Task 2: Learn how to play Baccarat

The game of Baccarat is simple. There are various versions, but we will focus on the simplest, called Punto Banco, which is played in Las Vegas and Macau. The following text will describe the algorithm in sufficient detail for completing this lab; if you need clarification or more information on any point, there are numerous tutorials on the web (Google is, as always, your friend).

#### Rules

- Two cards are dealt to both the player and the dealer (i.e., the banker) face up (first card to the player, second card to dealer, third card to the player, fourth card to the dealer).
- The score of each hand is computed as described under _Score_ below.
- If the player’s or banker’s hand has a score of 8 or 9, the game is over (this is called a “natural”) and whoever has the higher score wins (if the scores are the same, it is a tie)
- Otherwise, if the player’s score from his/her first two cards was 0 to 5:
  - the player gets a third card
  - the banker may get a third card depending on the following rule:
    1. If the banker’s score from the first two cards is 7, the banker does not take another card
    1. If the banker’s score from the first two cards is 6, the banker gets a third card if the face value of the player’s third card was a 6 or 7
	1. If the banker’s score from the first two cards is 5, the banker gets a third card if the face value of the player’s third card was 4, 5, 6, or 7
    1. If the banker’s score from the first two cards is 4, the banker gets a third card if the face value of player’s third card was 2, 3, 4, 5, 6, or 7
    1. If the banker’s score from the first two cards is 3, the banker gets a third card if the face value of player’s third card was anything but an 8
	1. If the banker’s score from the first two cards is 0, 1, or 2, the banker gets a third card.
- Otherwise, if the player’s score from his/her first two cards was 6 or 7:
  - the player does _not_ get a third card
  - if the banker’s score from his/her first two cards was 0 to 5:
    - the banker gets a third card
  - otherwise the banker does not get a third card
- The game is over. Scores are computed as below. Whoever has the higher score wins, or if they are the same, it is a tie.

#### Score

The score of each hand is computed as follows:

- The value of each card in each hand is determined. Each Ace, 2, 3, 4, 5, 6, 7, 8, and 9 has a value equal the face value (eg. Ace has value of 1, 2 is a value of 2, 3 has a value of 3, etc.). Tens, Jacks, Queens, and Kings have a value of 0.
- The score for each hand (which can contain up to three cards) is then computed by summing the values of each card in the hand, and the rightmost digit (in base 10) of the sum is the score of the hand. In other words, if Value1 to Value 3 are the values of Card 1 to 3, then

  Score of hand = (Value1 + Value2 + Value3) mod 10

  If the hand has only two cards, then Value3 is 0. You should be able to see that the score of a hand is always in the range [0,9].

It is interesting to note that in this version of the game, all moves are automatic (the player does not have to make any decisions!). The version played in Monte Carlo is slightly different, in that a player can choose whether or not to take a third card. We will not consider that here.


### Task 3: Understand the overall functionality your circuit should implement

First, consider the behaviour of the Baccarat circuit from the user’s point of view. As shown in the figure below, the circuit is connected to two input keys, a 50MHz clock, and the output of the circuit drives six seven-segment LEDs and ten lights.

<p align="center"><img src="figures/baccarat-circuit.png" width="50%" height="50%" title="the Baccarat circuit"></p>

The game starts by asserting the reset signal (KEY3) which is **active-low** and **synchronous**. The user can then step through each step of the game (deal one card to the player, one to the dealer, etc) by pressing KEY0 (this will be referred as **slow_clock** in this document). The exact sequence of states will be described below. As the cards are dealt, the player’s hand is shown on HEX0 to HEX2 (one hex digit per card — remember each hand can contain up to three cards) and the dealer’s hand is shown on HEX3 to HEX5. The current score of the player’s hand will be shown on lights LEGR3 to LEGR0 (recall that the score of a hand is always in the range [0,9] and can be represented using four bits), and the current score of the dealer’s hand will be shown on LEGR7 to LEGR4. We use lights to display the binary version of the score, since the DE1-SoC only has six hex digits.

There is also a 50MHz clock input; this is used solely for clocking the dealcard block which deals a random card. This will be described further in a subsequent task.

At the end of the game, red lights 8 and 9 will indicate the winner: if the player wins, light LEDR(8) goes high. (In your implementation, you may delay this until KEY0 has been pressed one more time after the winning card has been dealt). If the dealer wins, light LEDR(9) goes high. If it is a tie, both LEDR(8) and LEDR(9) go high. The system then does nothing until the user presses reset and clock, sending it back to the first state to deal another hand.

Notice that, other than cycling through the states using KEY0 (the slow clock), the user does not need to do anything. This is consistent with the description of the game above.


### Task 4: Understand the components of your circuit

The circuit consists of two parts: a state machine and a datapath. The datapath does all the “heavy lifting” (in this case, keeping track of each hand and computing the score for each hand) and the state machine controls the datapath (in this case, telling the datapath when to load a new card into either the player’s or dealer’s hand). The overall block diagram is shown below.

<p align="center"><img src="figures/block-diagram.png" width="50%" height="50%" title="block diagram"></p>

First consider the datapath, which consists of everything except the `statemachine` block in the block diagram. There are a number of subcircuits here, and each will be described below:

#### dealcard

To deal random cards, we need a random number generator. Random numbers are difficult to generate in hardware (can you suggest why?). We will use a few simple tricks. First, assume we are dealing from an infinite deck, so it is equally likely to generate any card, no matter which cards have been given out (casinos try to approximate this approach this by using multiple decks). Second, assume that when the player presses the “next step” key, an unpredictable amount of time has passed, representing a random delay. During this random delay interval, the subcircuit described in `dealcard.sv` will be continuously counting from the first card (Ace=1) to the last card (King=13), and then wrapping around to Ace=1 at a very high rate (e.g., 50MHz). To obtain a random card, we simply sample the current value of this counter when the user presses the “next step” key.

To save you time, we have written `dealcard.sv` for you. This block has two inputs (the fast clock and a synchronous reset) and one output (the card being dealt, represented by a number from 1 to 13 as described above). This circuit is essentially a counter. Be sure you understand it before moving on.

The design of `dealcard` raises an interesting point. Because you have two clocks (one from KEY0 driving the modules that use `dealcard` and the other from the 50MHz clock driving `dealcard` itself), you may rarely observe that the card dealt is not in the range 1..13. This is because the two clocks are _asynchronous_ — i.e., you might push KEY0 at just the right moment to sample the `dealcard` output when it is unstable. Can you reproduce this behaviour when testing in the FPGA?

You do not need to worry the asynchronous clocks for this lab, other than noticing when it happens. We will learn how to safely transmit signals among multiple clock domains and deal with asynchronous circuits later in the course.

#### reg4

Each card in each hand is stored in a `reg4` block, which is a 4-bit wide register (set of four D-flip-flops). The upper three reg4 blocks store the player’s hand, and the lower three `reg4` blocks store the dealer’s hand (recall each hand can have up to three cards). Each card is stored as a number from 1 to 13 (Ace=1, number cards are represented as themselves, Jack=11, Queen=12, King=13). We will not store the suit information for each card (the suit of a card does not matter in Baccarat). If a position in the hand does not have a card, we store a 0 to represent “no card”. As an example, if the player’s hand consists of a 5 and a Jack (and no third card), `PCard1` would contain the number 5, `PCard2` would contain the number 11, and `PCard3` would contain the number 0 (no card). Note that since there are 14 different possible values (including 0), four bits in each register is sufficient.

Each register is clocked using slow_clock (which is connected to KEY0 and toggled by the user). On each rising clock edge of slow_clock, if the enable signal (for `PCard1` the enable signal is called `load_pcard1`) is high, the value from dealcard is loaded into the register. The register also contains an active-low synchronous reset signal (which is connected to KEY3); if this is low, the value in the register goes to 0 on the next rising clock edge.

#### card7seg

This is the block you wrote in Phase 2. As you recall, this is a simple combinational circuit with a single 4-bit input (the value of a card encoded as above) and 7 outputs that drive a HEX according to the following pattern:

- The value 0 is “no card” and should be displayed as a blank (all HEX segments off)
- 1 is displayed as “A”, 10 is displayed as “0”, Jack as “J”, Queen as “q”, and King as “H”
- 2 through 9 are displayed as themselves, making sure the numeral 9 appears differently than “q”

You can use the block from Phase 2 directly; the inputs now come from registers rather than switches.

#### scorehand

This is a simple combinational circuit that takes the value of three cards and computes the score of that hand. Recall that the score of a hand is computed as follows:

1. The value of each of the three cards in each hand is determined. Each Ace, 2, 3, 4, 5, 6, 7, 8, and 9 has a value equal the face value (eg. Ace has value of 1, 2 is a value of 2, 3 has a value of 3, etc.). Tens, Jacks, Queens, and Kings have a value of 0. If fewer that three cards are in the hand, the missing positions are 0.
1. The values of the cards in each hand are summed, and the rightmost digit (in base 10) of the sum is the score of the hand. In other words, if Value1 is the value of the first card, Value2 is the value of the second card, and Value3 is the value of the third card, then

   Score of hand = (Value1 + Value2 + Value3) mod 10

You should be able to see that a hand can have a score in the range [0,9], thus 4 bits are sufficient for the output of this block.


#### statemachine

The state machine is the “brain” of our circuit. It has an active-low
synchronous reset (called resetb) and is clocked by slow_clock (which is
connected to KEY0). On each rising edge of slow_clock, the state machine
advances one step through the algorithm, and asserts the appropriate control
signals at each step. In this circuit, the control signals that the state
machine controls are load_pcard1, load_pcard2, … load_dcard3. When it is time
to deal the first card to the player, the state machine asserts load_pcard1,
which as was described above, causes the first Reg4 block to load in a card
(from the output of the dealcard block). During the cycle in which load_pcard1
is 1, all other load_pcard and load_dcard signals are 0, so that no other
positions in either hand are updated. As the algorithm progresses, the state
machine will generate the other control signals to be asserted at the
appropriate times.

As should be evident from the earlier discussion, the card drawing pattern
depends on the dealer score and the player score (these are used to determine
whether a third card is necessary) as well as the player’s third card (this is
used to determine whether the dealer should receive a third card, as described
in the rules). Therefore, pcard3, pscore, and dscore are inputs to the state
machine.

**The state machine must be busy doing something every clock cycle. Do not
insert `filler' / gap / no-op states. That is, your FSM should run in the
minimum number of clock cycles needed by dealing a new card on _every_ clock
cycle.  For example, you should not need separate clock cycles to score the
hand and then act on the score.**


#### initial implementation

To complete this task, create an initial implementation in Verilog that deals
the first four cards, alternating between the two players. Each player should
start with a score of 0, and the players score should update after receiving a
card.  Stop after the four cards have been dealt, ensuring each player's total
score is correct.

Your design must follow the hierarchical design approach shown below:

<p align="center"><img src="figures/hierarchy.svg" width="40%" height="40%" title="block diagram"></p>

To get you started, stubs for each of the files are in the `task4` folder. Be
sure to start with these, so that your interfaces for each module are correct
(**do not modify the interfaces**). The `reg4` block is not shown in the
diagram; you can either create a new module to describe a four-bit register, or
write it directly into `datapath.sv` (your choice, either will work). To help
you, we are giving you `dealcard.sv` and `task5.sv`. Be sure to also write a
testbench.


### Task 5: Baccarat code and testbenches

In this task, create testbenches and finish implementing the design.

Before trying to finish the Verilog hardware, start by writing unit tests for all your modules (you don't need to test `dealcard`, `card7seg`, or `reg4`). Each `tb_*.sv` file should test the corresponding module by providing inputs to the module's ports and examining the outputs, and test all of the code in the module. This also applies to the testbench for the toplevel module `task5`, which should only interface with the `task5` module and should not include the unit testbenches.

Be sure to exhaustively test **both** the SystemVerilog RTL code you write and the post-synthesis netlist Verilog file produced by Quartus (see the Tutorial).

The hardest part of this lab is getting the state machine right. We strongly urge you to draw (on paper) a bubble diagram showing the states, the transitions, and outputs of each transition. You are strongly urged to make sure you have your state machine bubble diagram done by the end of your Working Week lab. If you are unclear how to do this, be sure to discuss with your TA during the lab period. When drawing your diagram for your state machine, make sure that you cover all of the possible input conditions.


### Task 6: Verify your design on a (real or virtual) DE1-SoC board

Test your design by downloading it to the board and demo the working circuit to the TA. Remember that you should treat your TA as a client, and it is up to you to come up with an appropriate demo that shows that your design works. The TA will ask questions to gauge your understanding of the lab.

Remember to **commit** and **push** your `.sv` files to GitHub **before the deadline**. If you forget this, you will receive 0 marks for the lab. If your design works, you do not need to demo the datapath and state machine separately, just the entire design. However, if you are unable to get a working design, you should prepare to demo as many subunits on the DE1-SoC board as possible to the TA.



## Simulation and Code Coverage with ModelSim

Code coverage determines what proportion of your Verilog design has actually
been activated (aka "run") after simulation with your testbench completes. This
is always the result from running your testbench -- making your testbench more
complete will result in higher coverage.

Coverage can measure coverage of statements, branches, toggle bins, and more.
The goal of good simulation is to get each of these up to 100%.

Statement coverage shows the percentage of statements that have been executed
at least once during the testbench.  For example, if several logic statements
are protected by an if clause that is never activated throughout the
simulation, then those statements do not count as being covered.

Branches refer to the number of different execution paths that can be taken for
an if/else or case statement. For example, a case statement with 4 cases and a
default would have 5 branches. Even if you omit a default branch, ModelSim
still thinks it is there and counts it in terms of coverage.

Node coverage is reported in toggle bins. Each wire or node in your design has
two toggle bins, changing 0 to 1 or from 1 to 0, so there are twice as many
toggle bins as nodes. The report counts what proportion of these bins have been
activated at least once by the simulation.

ModelSim will also report coverage of the testbench file itself, but we never
look at this.  The tools also report coverage of all instances (full
hierarchy); your testbench should exercise as much of the complete hierarchy as
possible.

The free version of ModelSim that you installed with Quartus cannot measure
coverage. You may be able to access the commercial version ModelSim with a
license to run coverage, but this only runs on UBC's `ssh-soc` servers.
For access details, see [SSH Access](#ssh-access).

Here are the steps for running code coverage:

1. `$ ssh ssh-soc.ece.ubc.ca` (see SSH Access below)
1. `$ git clone https://<yourID>@github.com/UBC-CPEN311-Classrooms/2022w1-lab1-<yourID>.git`
1. `$ exec tcsh`
1. `% source /CMC/scripts/mentor.modelsim.10.7c.csh`
1. `$ exec bash`
1. Go to each task directory (eg, `task4`), and run the commands below.
1. `$ vlib work`
1. `$ vlog -l <dut>.rtl-vlog.rpt -cover bts -sv [tb files(s)] [dut file(s)]`
1. `$ vsim -L /CMC/tools/altera/19.1/modelsim_ase/altera/verilog/altera_mf -L /CMC/tools/altera/17.0/modelsim_ase/altera/verilog/cyclonev  -l tb_<dut>.rtl-vsim.rpt -c -coverage -do 'run <# ticks>; coverage report -file tb_<dut>.stats.rpt; quit' tb_<dut>`


<!---
FIXME: the libraries linked in the above vsim command; e.g.
	-L /CMC/tools/altera/19.1/modelsim_ase/altera/verilog/altera_mf
	-L /CMC/tools/altera/17.0/modelsim_ase/altera/verilog/cyclonev
are required to get Intel/Altera specific content included when running the
standalone installation of ModelSim on the ssh-soc server. Note that altera_mf
if only required if the design includes an Altera megafunction, and cyclonev
is only required to simulate post-synthesis. This means that neither include
is strictly required for this lab, however it should be ok to include them
here, and it means that this exact command can be copy and pasted for subsequent
labs.

Finally, note that the cyclonev device specific file is included from Quartus
17.0. This is due to some unfortunate Quartus versioning; it seems that 19.1
on the server is the 'Pro' version, which doesn't include cyclonev support, and
so we have to draw from 17.1, which is a 'Standard' version.
--->


When you run `exec tcsh`, the Linux prompt changes to indicate that you are now
using the tcsh command-line interpreter. In this environment, the command line
may respond differently to certain edit keystrokes and commands.  The tcsh
environment is only needed to run the setup script for modelsim; the `exec
bash` returns you back to the default bash command-line interpreter right away.

The `vlib` command creates a new modelsim design library. The `vlog` command
compiles your code. The `vsim` command runs the testbench simulation.  The
`bts` flag above tells ModelSim to report branches, toggle bins, and
statements. You can also try `e`xpression, `c`condition, and `x` for extended
toggle statistics.

For `tb_task5`, you can copy and paste below (except replace GITHUBID with your github name):

```
git clone https://GITHUBID@github.com/UBC-CPEN311-Classrooms/2022w1-lab-1-GITHUBID
exec tcsh
source /CMC/scripts/mentor.modelsim.10.7c.csh
exec bash
vlib work
vlog -l tb_task5.rtl-vlog.rpt -cover bts -sv tb_task5.sv task5.sv card7seg.sv datapath.sv dealcard.sv reg4.sv scorehand.sv statemachine.sv
vsim -L /CMC/tools/altera/19.1/modelsim_ase/altera/verilog/altera_mf -L /CMC/tools/altera/17.0/modelsim_ase/altera/verilog/cyclonev -l tb_task5.rtl-vsim.rpt -c -coverage -do 'run 1000000; coverage report -file tb_task5.stats.rpt; quit' tb_task5
less tb_task5.stats.rpt
```

For more detailed output, add `-lines`, and to ensure your testbench runs completely use `-all`:

```
vsim -l tb_task5.rtl-vsim.rpt -c -coverage -do 'run -all; coverage report -file tb_task5.stats.rpt -lines; quit' tb_task5
less tb_task5.stats.rpt
```

<!-- With the post-synthesis netlist, you may need:
FIXME: does this work on ssh-soc for coverage? or only on local PC?
```
vsim -gui -l msim_transcript -L cyclonev_ver -L altera_ver -L altera_lnsim_ver -L 220model_ver -L altera_mf_ver -L work work.tb_task4
```
-->

### SSH Access

To access the licensed ModelSim, you must be logged in to `ssh-soc.ece.ubc.ca`
via ssh. You can only access that server if you are already on the UBC network
such as a lab, residence, or UBC WiFi.  If you are away from UBC, eg at home,
you must first connect either directly using UBC's VPN service, or indirectly
using ssh to `ssh.ece.ubc.ca`.

To get your ECE account and (reset) your password, go to:
[https://id.ece.ubc.ca](https://id.ece.ubc.ca).

For UBC VPN access, see:
[https://it.ubc.ca/services/email-voice-internet/myvpn/setup-documents](https://it.ubc.ca/services/email-voice-internet/myvpn/setup-documents).

You can also run the ModelSim GUI if you use the X windows protocol:
[https://help.ece.ubc.ca/X2go](https://help.ece.ubc.ca/X2go).

You can also dump waveform files to a file, transfer the file to your PC, then
load the waveforms into ModelSim on your local PC.

The easiest way to return the coverage report files to your local PC is to
add/commit/push them to git on `ssh-soc`, and then pull them to your local PC.


## Deliverables and Evaluation

### Using GitHub

To complete your lab, you will need to

1. Clone this git repository (use `git clone`)
2. Modify the relevant files to complete each task
3. Add the files to commit (use `git add`)
4. Commit the files to your local copy of the repository (use `git commit`)
5. Push your copy of the repository to GitHub (use `git push`) and verify that your changes are reflected in the GitHub web interface

If you prefer, you may use the GitHub Desktop interface or another GUI instead of the command-line interface for git.

**WARNING: If you do not push the repository to GitHub, your lab will not be submitted and you will receive 0 marks for this lab.**

You must push your changes **before the deadline**. GitHub will automatically
copy the state of your (remote) repository as it appears at the deadline time,
and that will be considered your submission.

We strongly encourage you to commit and perhaps push changes as you make
progress. This is good development practice — this way, if you mess up and need
a previously working version, you can revert your files to a version you
committed earlier. To mark your lab, we will only examine the last version
commit pushed before the deadline, so don't worry about how messy your
in-progress commits might look.

You should commit **only** source files (in this lab, `.sv` files), and,
optionally, the post-synthesis netlist files generated by Quartus (the `.vo`
files). You do **not** need to commit the bitfile for programming the FPGA
(e.g., .sof files), waveform dumps, temporary files, and so forth. In
particular, be careful to not submit any **extra** `.sv` files that your design
does not use; our testing environment will process your submission
[as described below](#automatic-testing) and extra files that do not compile will
cause you to **fail** the tests. If you are using the virtual DE1-SoC for
testing, **do not** copy and submit any of the files from the `de1_gui` folder;
doing so will also cause you to fail the tests.

Any template files we give you (e.g., `card7seg.sv`) should be directly
modified and committed using **the same filename**, rather than copied and
modified.

NOTE 1: The repository created for you when you follow the assignment link is
private by default. **Do not** make it public — that would violate the academic
honesty rules for this course.

NOTE 2: We may be experimenting with a new GitHub Classroom feature that
simplifies TAs/instructor feedback. When it creates the remote lab repository
for you, it will automatically create a new development branch called
"feedback". Do not use this branch or create any other branches. By default,
all of your commits will be against the main branch called "master". The system
also automatically creates a "pull request" from the master branch to the
feedback branch.  This is a way of asking the feedback branch if it will accept
all of the commits made to the master branch. **DO NOT MERGE THIS PULL
REQUEST**. Instead, continue to make commits (and push those commits) as often
as you like. The commits, when pushed, will be added to the pull request. In
other words, this pull request becomes a handy way to view all of the changes
you have made to the assignment. More importantly, any of the collaborators on
your repository (you, a TA, or the instructor) can review changes made by any
commit and add comments or feedback. This is a potentially very valuable
feature for sharing your code with a TA/instructor and getting feedback, and
responding to that feedback. You can also push new commits, and these are
automatically folded in to the pull request to show improvements.


### Code coverage

TAs will ask you to show a coverage report for your each of modules, and the
entire design.  They will expect to see close to 100% coverage.

Check in a `*.stats.rpt` code coverage report file for each testbench.


### Post-synthesis simulation

Be sure to exhaustively test **both** the SystemVerilog RTL code you write and the post-synthesis netlist Verilog file produced by Quartus (see the Tutorial). It is **entirely possible** to write “unsynthesizable” RTL that works “in simulation” but either fails to synthesize or synthesizes into something that behaves differently. We will be assigning marks for **both** your RTL and the netlist we synthesize from it.

Optionally, you may include the post-synthesis netlist (`.vo` file) you generated from Quartus. We will not use it for marking, but it can provide evidence in the unlikely event that you need to appeal your marks.



### Marks Breakdown

We will use a simplified marking method this term. I will leave the previous
marking process below for you, so you know what you're missing. **Do** keep the
file names and structure as per the instructions in the "Old Marking Process"
shown below.

Your grade will have two components:
1. Demo and interview during your lab session: 10 marks (breakdown by task below)
2. Code quality check: grade multiplier 0.0 to 1.5

The demo/interview will consist of your demonstrating the Baccarat game to the
TA, and answering questions related to your code.  You will have
approximatively 10 minutes.  You will have to show working simulation, a
working synthesized design on the board, and coverage reports for the tasks
that you have completed.

Code quality will be checked from your Github submission.  It will be assigned
as a multiplier to the demo/interview grade, such that the maximum overall
grade is 15 out of 15 marks.  Details to pay attention to are:

- code readability
- comments to indicate purpose at the top of each source file and explanations for all modules, processes (**always** blocks)
- compliance with the three synthesizable patterns indicated in lecture 
- correct use of behavioural Verilog (i.e., if you instantiate low-level gates, registers, muxes etc., you will lose marks)
- completeness of testbenches and code coverage reports

<!--
We will also provide a submission completeness check to make sure you did not
miss any files from your Github classroom submission. If you submit your lab 1
by 11:59pm on the Friday night before the first lab marking session (Monday),
you will get a notification on the weekend about any potentially missing files
from your submitted lab assignment. The goal of this service is to encourage
you to finish your lab early, and to avoid late submissions (and consequently
loss of marks). This service will not be performed in future labs.
-->

**Do not submit any Virtual DE1-SoC files with the tasks below.**

#### Task 2 [2 marks]

Deliverables in folder `task1` (yes, that says task1):

- Modified `card7seg.sv`
- Modified `tb_card7seg.sv`
- Any other modified/added source or test files for your design

#### Task 4 [2 marks]

Deliverables in folder `task4`:

- Modified `card7seg.sv`
- Modified `statemachine.sv`
- Modified `scorehand.sv`
- Modified `datapath.sv`
- Any other modified/added source or test files for your design

The toplevel module of your design must be named `task4`.

#### Task 5 [6 marks]

Deliverables in folder `task5`:

- Modified `card7seg.sv`
- Modified `statemachine.sv`
- Modified `scorehand.sv`
- Modified `datapath.sv`
- Modified `tb_statemachine.sv`
- Modified `tb_scorehand.sv`
- Modified `tb_datapath.sv`
- Modified `tb_task5.sv`
- All `*.stats.rpt` files showing coverage results for all testbench files.
- Any other modified/added source or test files for your design

The toplevel module of your design must be named `task5`.



## Autograder Marking Process

The autograder will not be used in 2024W1. This section is kept intact for
legacy purposes.

In the past, the course placed a heavy emphasis on automated testing of labs.
This section is left here for legacy purposes.  **In particular, you should
follow the rules below about not modifying filenames or module/port/signal
declarations that have been provided to you.**

It is essential that you understand how this works so that you submit the
correct files — if our testsuite is unable to compile and test your code, you
will not receive marks.

The testsuite evaluates each task separately. For each design task folder
(e.g., `task5`), it collects all Verilog files (`*.sv`) that do not begin with
`tb_` and compiles them **all together**, both using Modelsim and using
Quartus. Separately, each required `tb_*.sv` file is compiled with the relevant
`*.sv` design files. This means that

1. You must not **rename any files** we have provided.
2. You must not **add** any files that contain unused Verilog code; this may cause compilation to fail.
3. Your testbench files must begin with `tb_` and **correspond to design file names** (e.g., `tb_scorehand.sv` for `scorehand.sv`).
4. You must not have **multiple copies of the same module** in separate committed source files in the same task folder. This will cause the compiler to fail because of duplicate module definitions.
5. Your modules must not **rely on files from another folder** (e.g., you will need a separate copy of `card7seg.sv` in the `task5` folder, as well as a separate copies of all relevant files in `task7`). The autograder will only look in the relevant task folder.

The autograder will instantiate and test each module exactly the way it is defined in the provided skeleton files. This means that
1. You must not **alter the module declarations, port lists, etc.**, in the provided skeleton files.
2. You must not **rename any modules, ports, or signals** in the provided skeleton files.
3. You must not **alter the width or polarity of any signal** in the skeleton files (e.g., `resetb` is synchronous and must remain active-low).

Tests will be done first on the RTL code you submit (the `.sv` files). The
autograder will then synthesize your design using Quartus, and run its tests on
the post-synthesis Verilog files (the `.vo` files). Note that, while you
[may optionally submit](#post-synthesis-simulation) the `.vo` files you synthesized,
we will use our own synthesis results for marking.

If your code does not compile and simulate in ModelSim or does not synthesize
in Quartus under these conditions (e.g., because of syntax errors, misconnected
ports, or missing files, non-synthesizable RTL), you will receive **0 marks**
for the relevant portion of the grade.

### Autograder Marks

The automated evaluation of your submission consists of several parts:
- **30%**: automatic testing of your RTL code (your `*.sv`)
- **20%**: automatic testing of your testbenches and how much of your code they cover (your `tb_*.sv` and `*.sv`)
- **50%**: automatic testing of the synthesized netlist (synthesized from your `*.sv`)
