process PYOPENMS_MSMAPPING{
    tag "$meta.id"
    label 'process_medium'

    conda "bioconda::pyopenms=2.9.1"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/pyopenms:2.9.1--py311h9b8898c_3' :
        'biocontainers/pyopenms:2.9.1--py311h9b8898c_3' }"

    input:
    tuple val(meta), path(input_target),path(input_spectra)


    output:
    tuple val(meta),path("output/*.consensusXML"), emit: consensusxml
    path  "versions.yml"                      , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def mzml_input        = input_spectra.collect { it }.join(' ')
        """
    mkdir output

    extract_mapping.py \\
        --consensus_input $input_target --mzml_file_paths $mzml_input --output output/${prefix}.consensusXML $args


    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        pyopenms: \$(python -c "import pyopenms; print(pyopenms.__version__)" 2>/dev/null)
    END_VERSIONS
        """
}
