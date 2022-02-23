package repository

type IRedis interface {
	Get(key string) (interface{}, error)
}