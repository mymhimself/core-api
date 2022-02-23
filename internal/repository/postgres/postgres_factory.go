package postgres


import (
	"fmt"
	"github.com/mymhimself/core-api/config"
	"github.com/mymhimself/core-api/pkg/logger"
	"github.com/mymhimself/core-api/internal/repository"
	driver "gorm.io/driver/postgres"
	"gorm.io/gorm"
)

type postgres struct {
	db              *gorm.DB
	logger          logger.Logger
	dataProtocolCfg config.DataProtocol
}

func NewPostgres(cfg config.Postgres, dataProtocolCfg config.DataProtocol, logger logger.Logger) (repository.IPostgres, error) {
	dsn := fmt.Sprintf("host=%s user=%s dbname=%s sslmode=disable password=%s",
						cfg.Host, 
						cfg.Username, 
						cfg.DBName, 
						cfg.Password)
						
	conn, err := gorm.Open(driver.Open(dsn), &gorm.Config{})
	if err != nil {
		return nil, repository.ErrDatabaseSetupFailed
	}

	return &postgres{db: conn, logger: logger, dataProtocolCfg: dataProtocolCfg}, nil
}