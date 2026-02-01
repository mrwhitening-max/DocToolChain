outputPath = 'build'

inputPath = 'src/docs'

inputFiles = [
    [file: 'arc42.adoc', formats: ['html', 'pdf']],
]

imageDirs = [
    'images/.',
]

taskInputsDirs = [
    "${inputPath}",
]
taskInputsFiles = []