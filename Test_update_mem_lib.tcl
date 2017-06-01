cd run/mem_lib
source ../../tools/scr/config.tcl

# determine the unique list of corners
foreach corner_var [info globals MEM_*_LIB] {
    upvar #0 $corner_var corner
    lappend corners $corner
}
set corners [lsort -unique $corners]

foreach corner $corners {
    if {![info exists MEM_PVT_CHANGE($corner)]} {
        set MEM_PVT_CHANGE($corner) -nopvtchange
    }
}


set mem_list {}
foreach mem $RTL_MEM {

    # get/cache the current compiler versions
    regexp {^([a-z_]+)\d+} $mem match mem_type
    if {! [info exists compiler_versions($mem_type)] } {
        # E5: doesn't work in IL
        set  compiler_versions($mem_type) [exec $env(TECH_ROOT)/$env(PROCESS)/stdcell/gen_mem.pl -getversion $mem_type]
    }


    if {[file exists ${PNRPATH}/comp_mem/vclef/${mem}.vclef]} {
        set diff_retVal [diff_leffile \
                             -input_lef ${PNRPATH}/comp_mem/vclef/${mem}.vclef \
                             -output_lef ${VCLEF_DIR}/${mem}.vclef]
        set version [get_version_from_lef ${PNRPATH}/comp_mem/vclef/${mem}.vclef]

        # if compiler version has changed
        if {$version != $compiler_versions($mem_type)} {
            puts "Information: Ram out of date: $mem existing lef version: $version.  New compiler version $compiler_versions($mem_type)"
            set diff_retVal 1
            # E5: potential workaround needed for IL
            exec rm ${PNRPATH}/comp_mem/vclef/${mem}.vclef
        }
    } else {
        set diff_retVal 1
    }
        foreach corner $corners {
            if {![file exists "${LIB_DIR}/${mem}_${corner}_syn.lib"] ||
                [eval "diff_libfiles -outlib ${LIB_DIR}/${mem}_${corner}_syn.lib -inlib ${PNRPATH}/comp_mem/lib/${mem}_${corner}_syn.lib $MEM_PVT_CHANGE($corner)"] } {
                lappend mem_list $mem
                break
            }
        }
}

puts "Information: mem_list is $mem_list"

# determine which memories in mem_list need to be generated (in $pnrpath/comp_mem/, to later be copied over to local dirs)
set gen_mem_list {}
foreach mem $mem_list {
        set file_not_found 0
        foreach m_file [list ${PNRPATH}/comp_mem/vclef/$mem.vclef \
                            ${PNRPATH}/comp_mem/hdl/${mem}.v \
                            ${PNRPATH}/comp_mem/ctl/${mem}.ctl \
                            ${PNRPATH}/comp_mem/gds/${mem}.gds \
                            ${PNRPATH}/comp_mem/cdl/${mem}.cdl ] {
            if {![file exists $m_file]} {
                puts "Information: can't find $m_file"
                set file_not_fount 1
                lappend gen_mem_list $mem
                break
            }
        }

        if {!$file_not_found} {
            foreach corner $corners {
                if {![file exists "${PNRPATH}/comp_mem/lib/${mem}_${corner}_syn.lib"]} {
                    puts "Information: $mem corner $corner not found"
                    lappend gen_mem_list $mem
                    break
                }
            }
        }
}


set gen_mem_list [lsort -unique $gen_mem_list]
set num_mem [llength $gen_mem_list]


