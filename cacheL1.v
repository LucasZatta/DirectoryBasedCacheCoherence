module cacheL1(
    input clk, 
    input [7:0] addressP0, input operationP0, input [7:0] dataP0,
    input dataReplyPresent, input [7:0] dataReply,

    input [2:0] FromInterconnection, busAddress, input [7:0] addressRequested,

    output dataSupplyPresent, output [7:0] dataOut, dataSupply, 
    output writeBack,  output [3:0] ToInterconnection, output [7:0] requestAddress
    );

    //l1 com 1 bit de index
    reg [6:0] tag[0:1]; 
    reg [1:0] coherencyStates[0:1];
    reg [7:0] data[0:1];

    wire readMissOnBus, writeMissOnBus, invalidateOnBus, dataWriteBackMachine1, dataWriteBackMachine2;
    wire [1:0] newState, newStateFromBus;

    wire index = addressP0[0];
    wire [6:0]tagWire = addressP0[7:1];
    wire hit =  &{tag[index] ~^ tagWire};

    wire busIndex = busAddress[0];
    wire [6:0]tagWireBus = busAddress[7:1];
    wire dataSupplyPresent =  &{tag[busIndex] ~^ tagWireBus};

    wire [1:0]state = coherencyStates[index];
    wire [1:0]stateAttendingBus = coherencyStates[busIndex];

    assign ToInterconnection = {readMissOnBus, writeMissOnBus, invalidateOnBus};
    assign writeBack = dataWriteBackMachine1 | dataWriteBackMachine2;

    assign dataOut = data[index];
    assign dataSupply = data[addressRequested];

    assign requestAddress = addressP0;
    
    directoryStateMachineCPU machineL1(
        operationP0, hit, state,
        readMissOnBus, writeMissOnBus, invalidateOnBus, dataWriteBackMachine1, newState
    );
    directoryStateMachineBus machineL1_2(
        FromInterconnection[2], FromInterconnection[1], FromInterconnection[0], 
        stateAttendingBus,
        //outputs
        newStateFromBus, dataWriteBackMachine2, dataSupplyPresent
    );

    always @(posedge clk) begin
        coherencyStates[index] <= newState;
        tag[index] <= tagWire;
        if(operationP0 == 1'b1) begin
            data[index] <= dataP0;    
        end
        coherencyStates[busIndex] <= newStateFromBus;
        if(dataReplyPresent == 1'b1) begin
            data[index] <= dataReplyL1; 
        end
    end

endmodule
