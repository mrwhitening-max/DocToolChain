outputPath = 'build'

inputPath = 'src'

inputFiles = [
    [file: 'arc42.adoc', formats: ['html', 'pdf']],
]

imageDirs = [
    'images/.',
]

taskInputsDirs = [
    "${inputPath}",
    "${inputPath}/docs",
    "${inputPath}/images",
]
taskInputsFiles = []