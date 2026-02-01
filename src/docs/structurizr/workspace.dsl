workspace {

    model {
        user = person "User" "Endanwender"

        softwareSystem = softwareSystem "SoftwareSystem" {
            webapp = container "Web Application" "Java/Spring Boot"
            database = container "Database" "PostgreSQL"

            webapp -> database "Liest/Schreibt" "SQL/TCP"
        }

        user -> webapp "Nutzt" "HTTPS"

        deploymentEnvironment "Production" {
            deploymentNode "AWS" {
                region = deploymentNode "eu-central-1" {

                    # Infrastructure Nodes
                    alb = infrastructureNode "Application Load Balancer"
                    webSg = infrastructureNode "Web Security Group"
                    dbSg = infrastructureNode "Database Security Group"

                    azA = deploymentNode "Availability Zone A" {
                        deploymentNode "EC2 Instance 1" {
                            webappInst1 = containerInstance webapp
                        }
                    }
                    azB = deploymentNode "Availability Zone B" {
                        deploymentNode "EC2 Instance 2" {
                            webappInst2 = containerInstance webapp
                        }
                    }
                    azC = deploymentNode "Availability Zone C" {
                        deploymentNode "EC2 Instance 3" {
                            webappInst3 = containerInstance webapp
                        }
                    }

                    deploymentNode "RDS Multi-AZ" {
                        dbInst = containerInstance database
                    }

                    # --- NUR INFRA-BEZIEHUNGEN ---
                    # Das hier ist meistens das Problem. Wir verbinden Infra zu Instanz:
                    alb -> webappInst1 "Forwarded"
                    alb -> webappInst2 "Forwarded"
                    alb -> webappInst3 "Forwarded"

                    webSg -> alb "Sichert"
                    dbSg -> dbInst "Sichert"
                }
            }
        }
    }

    views {
        deployment softwareSystem "Production" "AWS_HA_Sicht" {
            # 'include *' nimmt automatisch den 'user' und seine Beziehung zur 'webapp' mit auf.
            # Da 'user -> webapp' im Modell existiert, zeichnet Structurizr die Linie
            # zu den Instanzen AUTOMATISCH, ohne dass wir sie manuell im Deployment definieren müssen.
            include *
            autolayout lr
        }

        styles {
            element "Infrastructure Node" {
                background #ffffff
                color #000000
                shape RoundedBox
            }
        }
    }
}