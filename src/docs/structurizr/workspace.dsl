workspace {

    model {
        user = person "User" "Ein Endanwender"

        softwareSystem = softwareSystem "Mein Software System" {
            webapp = container "Web Application" "Java/Spring Boot"
            database = container "Database" "PostgreSQL"

            webapp -> database "Liest von/schreibt auf" "SQL/TCP"
        }

        # WICHTIG: Die logische Verbindung bleibt bestehen
        user -> webapp "Nutzt die Anwendung" "HTTPS"

        deploymentEnvironment "Production" {
            deploymentNode "AWS" {
                tags "Amazon Web Services - Cloud"

                region = deploymentNode "eu-central-1" {

                    # Infrastructure Nodes
                    webSg = infrastructureNode "Web Security Group"
                    dbSg = infrastructureNode "Database Security Group"
                    alb = infrastructureNode "Application Load Balancer"

                    azA = deploymentNode "Availability Zone A" {
                        deploymentNode "EC2 Instance" {
                            webappInst1 = containerInstance webapp
                        }
                    }
                    azB = deploymentNode "Availability Zone B" {
                        deploymentNode "EC2 Instance" {
                            webappInst2 = containerInstance webapp
                        }
                    }
                    azC = deploymentNode "Availability Zone C" {
                        deploymentNode "EC2 Instance" {
                            webappInst3 = containerInstance webapp
                        }
                    }

                    rds = deploymentNode "AWS RDS" {
                        dbInst = containerInstance database
                    }

                    # --- FIX: Die korrekte Kette ---
                    # Wir lassen den User die Instanzen direkt ansprechen (logisch erlaubt)
                    # UND beschreiben den Weg über die Infrastruktur.

                    user -> webappInst1 "Anfrage via ALB" "HTTPS"
                    user -> webappInst2 "Anfrage via ALB" "HTTPS"
                    user -> webappInst3 "Anfrage via ALB" "HTTPS"

                    # Die Infrastruktur-Beziehungen untereinander sind erlaubt:
                    alb -> webappInst1 "Forwarded zu"
                    alb -> webappInst2 "Forwarded zu"
                    alb -> webappInst3 "Forwarded zu"

                    # Security Groups
                    webSg -> alb "Sichert"
                    dbSg -> dbInst "Sichert"
                }
            }
        }
    }

    views {
        systemContext softwareSystem "SystemContext" {
            include *
            autolayout lr
        }

        container softwareSystem "Containers" {
            include *
            autolayout lr
        }

        deployment softwareSystem "Production" "AWS_HA_Sicht" {
            include *
            autolayout lr
        }

        theme default

        styles {
            element "Infrastructure Node" {
                background #ffffff
                color #000000
                shape RoundedBox
            }
        }
    }
}