workspace {

    model {
        user = person "User" "Ein Endanwender"

        softwareSystem = softwareSystem "Mein Software System" {
            webapp = container "Web Application" "Java/Spring Boot"
            database = container "Database" "PostgreSQL"

            webapp -> database "Liest von/schreibt auf" "SQL/TCP"
        }

        # Diese logische Beziehung ist die Basis
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

                    # --- DIE LÖSUNG FÜR DEN FEHLER ---
                    # 1. User zu Infrastruktur (ALB)
                    user -> alb "HTTPS Requests"

                    # 2. Infrastruktur zu Container-Instanzen
                    # Wichtig: Wir verbinden das ALB mit den konkreten Instanzen
                    alb -> webappInst1 "Verteilt Traffic"
                    alb -> webappInst2 "Verteilt Traffic"
                    alb -> webappInst3 "Verteilt Traffic"

                    # Optional: Security Group Visualisierung
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
}workspace {

    model {
        user = person "User" "Ein Endanwender"

        softwareSystem = softwareSystem "Mein Software System" {
            webapp = container "Web Application" "Java/Spring Boot"
            database = container "Database" "PostgreSQL"

            webapp -> database "Liest von/schreibt auf" "SQL/TCP"
        }

        # Diese logische Beziehung ist die Basis
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

                    # --- DIE LÖSUNG FÜR DEN FEHLER ---
                    # 1. User zu Infrastruktur (ALB)
                    user -> alb "HTTPS Requests"

                    # 2. Infrastruktur zu Container-Instanzen
                    # Wichtig: Wir verbinden das ALB mit den konkreten Instanzen
                    alb -> webappInst1 "Verteilt Traffic"
                    alb -> webappInst2 "Verteilt Traffic"
                    alb -> webappInst3 "Verteilt Traffic"

                    # Optional: Security Group Visualisierung
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