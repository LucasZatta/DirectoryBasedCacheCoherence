module directoryStateMachineCPU(input operation, hit, input[1:0] cpuInitialState, output reg readMissOnBus, writeMissOnBus, invalidateOnBus, dataWriteBack, output [1:0] cpuNewState);
//
//invalidate
//shared
//modified
//escrita 1, leitura 0
parameter INVALID = 2'b01, SHARED = 2'b10, MODIFIED = 2'b11;

initial begin
    readMissOnBus <= 1'b0;
    writeMissOnBus <= 1'b0;
    invalidateOnBus <= 1'b0;
    dataWriteBack <= 1'b0;
end

always @(*) begin
    case(cpuInitialState)
        INVALID: begin
            if(operation == 1'b0) begin //read
                cpuNewState <= SHARED;
                readMissOnBus <=  1'b1;
                writeMissOnBus <= 1'b0;
                invalidateOnBus <= 1'b0;
                dataWriteBack <= 1'b0;
            end 
            else if(operation==1'b1) begin //write
                cpuNewState <= MODIFIED;
                writeMissOnBus <= 1'b1;
                readMissOnBus <= 1'b0;
                invalidateOnBus <= 1'b0;
                dataWriteBack <= 1'b0;
            end
        end
        
        SHARED: begin
            case({operation, hit}) 
                2'b00: begin //read miss PRA ESCRITA SEMPRE MODIFIED
                    cpuNewState <= SHARED;
                    writeMissOnBus <= 1'b0;
                    invalidateOnBus <= 1'b0;
                    readMissOnBus <= 1'b1;
                    dataWriteBack <= 1'b0;
                end

                2'b01: begin //read hit
                    cpuNewState <= SHARED;
                    writeMissOnBus <= 1'b0;
                    invalidateOnBus <= 1'b0;
                    readMissOnBus <= 1'b0;
                    dataWriteBack <= 1'b0;
                end

                2'b10: begin // write miss
                    cpuNewState <= MODIFIED;
                    writeMissOnBus <= 1'b1;
                    invalidateOnBus <= 1'b0;
                    readMissOnBus <= 1'b0;
                    dataWriteBack <= 1'b0;
                end

                2'b11: begin // write hit
                    cpuNewState <= MODIFIED;
                    writeMissOnBus <= 1'b0;
                    invalidateOnBus <= 1'b1;
                    readMissOnBus <= 1'b0;
                    dataWriteBack <= 1'b0;
                end
            endcase
        end

        MODIFIED: begin
            case({operation, hit}) 
                2'b00: begin //read miss PRA ESCRITA SEMPRE MODIFIED
                    cpuNewState <= SHARED;
                    writeMissOnBus <= 1'b0;
                    invalidateOnBus <= 1'b0;
                    readMissOnBus <= 1'b1;
                    dataWriteBack <= 1'b1;
                end

                2'b01: begin //read hit
                    cpuNewState <= MODIFIED;
                    writeMissOnBus <= 1'b0;
                    invalidateOnBus <= 1'b0;
                    readMissOnBus <= 1'b0;
                    dataWriteBack <= 1'b0;
                end

                2'b10: begin // write miss
                    cpuNewState <= MODIFIED;
                    writeMissOnBus <= 1'b1;
                    invalidateOnBus <= 1'b0;
                    readMissOnBus <= 1'b0;
                    dataWriteBack <= 1'b1;
                end

                2'b11: begin // write hit
                    cpuNewState <= MODIFIED;
                    writeMissOnBus <= 1'b0;
                    invalidateOnBus <= 1'b0;
                    readMissOnBus <= 1'b0;
                    dataWriteBack <= 1'b0;
                end
            endcase
        end

    endcase
end

endmodule


module directoryStateMachineBus(input readMiss, invalidate, writeMiss, input[1:0] busInitialState, output[1:0] busNewState)

endmodule


