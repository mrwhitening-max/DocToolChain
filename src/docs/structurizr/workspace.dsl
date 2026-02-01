workspace {

    model {
        user = person "User"
        softwareSystem = softwareSystem "Software System" {
            webapp = container "Web Application" "Java/Spring Boot App"
            database = container "Database" "PostgreSQL" {
                webapp -> this "Reads from and writes to"
            }
        }

        user -> webapp "Uses"

        # --- Deployment Environment ---
        deploymentEnvironment "Production" {

            deploymentNode "AWS" {
                tags "Amazon Web Services - Cloud"

                region = deploymentNode "eu-central-1" {
                    tags "Amazon Web Services - Region"

                    # Infrastructure: Load Balancer & SG
                    webSg = infrastructureNode "Web Security Group" "Allows HTTP/S traffic"
                    alb = infrastructureNode "Application Load Balancer" "Verteilt Traffic auf EC2 Instanzen" {
                        webSg -> this "Secures"
                    }

                    # Availability Zone 1
                    az1 = deploymentNode "Availability Zone 1" {
                        tags "Amazon Web Services - Availability Zone"

                        deploymentNode "EC2 Instance" {
                            containerInstance webapp
                        }
                    }

                    # Availability Zone 2
                    az2 = deploymentNode "Availability Zone 2" {
                        tags "Amazon Web Services - Availability Zone"

                        deploymentNode "EC2 Instance" {
                            containerInstance webapp
                        }
                    }

                    # Availability Zone 3
                    az3 = deploymentNode "Availability Zone 3" {
                        tags "Amazon Web Services - Availability Zone"

                        deploymentNode "EC2 Instance" {
                            containerInstance webapp
                        }
                    }

                    # Database Layer (Multi-AZ RDS)
                    dbSg = infrastructureNode "Database Security Group" "Allows SQL traffic from Web SG"

                    deploymentNode "RDS Multi-AZ" {
                        tags "Amazon Web Services - RDS"
                        containerInstance database
                    }

                    # Connections in Deployment
                    user -> alb "HTTPS Requests"
                    alb -> webapp "Forwards requests to"
                    dbSg -> database "Secures"
                }
            }
        }
    }

    views {
        systemContext softwareSystem {
            include *
            autolayout lr
        }

        container softwareSystem {
            include *
            autolayout lr
        }

        # Die neue Deployment Sicht
        deployment softwareSystem "Production" "AWS_HA_Deployment" {
            include *
            autolayout lr
            description "Hochverfügbare Verteilung über 3 AZs mit ALB und RDS."
        }

        theme default

        # Optional: Styling für AWS Komponenten
        styles {
            element "Amazon Web Services - Cloud" {
                background #ffffff
                color #000000
            }
            element "Infrastructure Node" {
                shape RoundedBox
                background #ffffff
            }
        }
    }
}