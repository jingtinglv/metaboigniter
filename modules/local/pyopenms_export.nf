process PYOPENMS_EXPORT {
    tag "$meta.id"
    label 'process_medium'

    conda "bioconda::pyopenms=2.9.1"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/pyopenms:2.9.1--py311h9b8898c_3' :
        'biocontainers/pyopenms:2.9.1--py311h9b8898c_3' }"



    input:
    tuple val(meta), path(consensusxml)
    tuple val(meta_sirius), path(sirius)
    tuple val(meta_fingerid), path(fingerid)
    tuple val(meta_ms2qurry), path(ms2qurry)

    output:
    tuple val(meta), path("output_*.tsv")     , emit: tsv
    path  "versions.yml"               , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def sirius_id = sirius ? "output_${meta_sirius.id}.tsv": '""'
    def finger_id = fingerid ? "output_${meta_fingerid.id}.tsv": '""'
    def ms2query_id = ms2qurry ? "output_${meta_ms2qurry.id}.tsv": '""'
    def sirius_file = sirius ? sirius: '""'
    def finger_file = fingerid ? fingerid: '""'
    def ms2query_file = ms2qurry ? ms2qurry: '""'

        """

        cleanup.py --input_consensus $consensusxml --output output_quantification_${prefix}.tsv --sirius_id $sirius_id --finger_id $finger_id --ms2query_id $ms2query_id --sirius_file $sirius_file --finger_file $finger_file --ms2query_file $ms2query_file  $args

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        pyopenms: \$(python -c "import ms2query; print(ms2query.__version__)" 2>/dev/null)
    END_VERSIONS
        """
}
