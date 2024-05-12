workflow MS1peak_FA {

    process run_R_script {
        script:
        """
        cd /mnt/d/workspace/r_studio_work/metaboanalysis/ms1_peak
        /mnt/d/software2/R-4.3.3/bin/Rscript.exe "D:\\workspace\\r_studio_work\\metaboanalysis\\ms1_peak\\mumichog.R"
        """
    }

    process copy_results {
        script:
        """
        mkdir ${workflow.workDir}/result
        cp /mnt/d/workspace/r_studio_work/metaboanalysis/ms1_peak/mummichog_matched_compound_all.csv  ${workflow.workDir}/result/
        cp /mnt/d/workspace/r_studio_work/metaboanalysis/ms1_peak/mummichog_pathway_enrichment_mummichog.csv  ${workflow.workDir}/result/
        cp /mnt/d/workspace/r_studio_work/metaboanalysis/ms1_peak/peaks_to_paths_ms1_dpi72.pdf  ${workflow.workDir}/result/
        """
    }
}

