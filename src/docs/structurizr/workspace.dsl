workspace {

    model {
        user = person "User" "Ein Endanwender des Systems"

        softwareSystem = softwareSystem "Mein Software System" {
            webapp = container "Web Application" "Java/Spring Boot"
            database = container "Database" "PostgreSQL"

            webapp -> database "Liest von und schreibt auf" "SQL/TCP"
        }

        user -> webapp "Nutzt die Anwendung" "HTTPS"

        # --- DEPLOYMENT MUSS VOR DEN VIEWS STEHEN ---
        production = deploymentEnvironment "Production" {
            deploymentNode "AWS" {
                tags "Amazon Web Services - Cloud"

                region = deploymentNode "eu-central-1" {

                    # Infrastructure Nodes
                    webSg = infrastructureNode "Web Security Group" "Erlaubt Port 443"
                    dbSg = infrastructureNode "Database Security Group" "Erlaubt Port 5432"
                    alb = infrastructureNode "Application Load Balancer" "Externer HTTPS Load Balancer"

                    # 3 Availability Zones
                    azA = deploymentNode "Availability Zone A" {
                        deploymentNode "EC2 Instance" "t3.medium" {
                            webappInst1 = containerInstance webapp
                        }
                    }
                    azB = deploymentNode "Availability Zone B" {
                        deploymentNode "EC2 Instance" "t3.medium" {
                            webappInst2 = containerInstance webapp
                        }
                    }
                    azC = deploymentNode "Availability Zone C" {
                        deploymentNode "EC2 Instance" "t3.medium" {
                            webappInst3 = containerInstance webapp
                        }
                    }

                    # Multi-AZ RDS
                    rds = deploymentNode "AWS RDS" "Managed Database Service" {
                        dbInst = containerInstance database
                    }

                    # Deployment-Beziehungen
                    user -> alb "HTTPS Requests"
                    alb -> webappInst1 "Forwarded"
                    alb -> webappInst2 "Forwarded"
                    alb -> webappInst3 "Forwarded"

                    # Security Group Visualisierung
                    webSg -> alb "Sichert"
                    dbSg -> dbInst "Sichert"
                }
            }
        }
    }

    views {
        # Explizite Keys (z.B. "SystemContext") verhindern die Warnung im Log
        systemContext softwareSystem "SystemContext" {
            include *
            autolayout lr
        }

        container softwareSystem "Containers" {
            include *
            autolayout lr
        }

        # Jetzt findet der Parser das Environment "Production"
        deployment softwareSystem "Production" "AWS_HA_Sicht" {
            include *
            autolayout lr
            description "Hochverfügbare AWS Architektur über 3 AZs."
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