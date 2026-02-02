outputPath = 'build'

inputPath = 'src'

inputFiles = [
    [file: 'arc42.adoc', formats: ['html', 'pdf', 'epub']],
]

imageDirs = [
    'images/.',
    'src/docs/structurizr/diagrams' // <--- Diesen Pfad hinzufügen
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