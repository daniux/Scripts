# grab env vars
set PNRMNT   $env(PNRMNT)
# E5: won't work in IL
set PNRWORK  $PNRMNT/work
#set TOP_DIR  $PNRMNT/work

# run the ARM compiler, if necessary
if [info exists gen_mem_list] {

    set num_mem [llength $gen_mem_list]
    set log_id [lindex $gen_mem_list 0]
    set mem_str "memory"
    if {$num_mem > 1} { set mem_str "memories" }

    # generate the needed memories
    puts -nonewline "Information: generating .lib, .vclef, and .v files for $num_mem $mem_str..."
    flush stdout
    # E5: won't work in IL
    # ${PROCESS_ROOT} -> /nfs/catech/process/cmos14lpp/
    # /nfs/catech/process/cmos14lpp/stdcell/gen_mem.pl
    set status [catch "exec ${PROCESS_ROOT}/stdcell/gen_mem.pl -ctl -lib -vclef -verilog -tmax -gds -cdl -ascii $gen_mem_list >gen_mem.${log_id}.log 2>gen_mem.${log_id}.errlog" result]
    #set status 0

    if {$status != 0} {
        puts "FAILED"
        puts stderr "Error: failed getting .lib, .vclef, and .v files, see [pwd]/gen_mem.errlog for details"
        exit $status
    } else {
        puts "done."
    }
}
