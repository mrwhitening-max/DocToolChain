outputPath = 'build'

inputPath = 'src'

inputFiles = [
    // epub zu Formaten hinzugefügt
    [file: 'arc42.adoc', formats: ['html', 'pdf', 'epub']],
]

imageDirs = [
    'images/.',
    // Pfad für Structurizr-Diagramme hinzugefügt, damit sie im EPUB landen
    'src/docs/structurizr/diagrams'
]

taskInputsDirs = [
    "${inputPath}",
    "${inputPath}/docs",
    "${inputPath}/images",
]
taskInputsFiles = []

structurizr = [:]

structurizr.with {
    workspace = {
        path = 'src/docs/structurizr'
    }
    export = {
        outputPath = 'src/docs/structurizr/diagrams'
        format = 'plantuml/c4plantuml'
    }
}