// 截流函数
class Throttle {
  private delay: number
  private lastExecutionTime: number
  private timerId: any

  constructor(delay: number) {
    this.delay = delay
    this.lastExecutionTime = 0
    this.timerId = null
  }

  execute(callback: (...args: any[]) => void, ...args: any[]) {
    const currentTime = Date.now()
    const elapsed = currentTime - this.lastExecutionTime

    if (elapsed < this.delay) {
      if (this.timerId) {
        clearTimeout(this.timerId)
      }

      this.timerId = setTimeout(() => {
        this.lastExecutionTime = currentTime
        this.timerId = null
        callback(...args)
      }, this.delay - elapsed)
    } else {
      this.lastExecutionTime = currentTime
      callback(...args)
    }
  }
}

export { Throttle }
// const processClick = () =>{}

// // 使用方式
// const throttle = new Throttle(1000) // 设置 1000ms 的截流时间间隔

// window.addEventListener('click', (event) => {
//   throttle.execute(processClick, event) // 执行被截流的回调函数
// })
