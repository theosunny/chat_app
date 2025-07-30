// 测试当前认证状态的脚本
const axios = require('axios');

// 模拟检查认证状态
async function checkAuthStatus() {
  try {
    console.log('正在检查认证状态...');
    
    // 测试需要认证的接口
    const response = await axios.get('http://localhost:8080/api/user/profile', {
      headers: {
        'Authorization': 'Bearer test_token' // 这里应该是实际的token
      }
    });
    
    console.log('认证成功:', response.data);
  } catch (error) {
    if (error.response) {
      console.log('认证失败:', error.response.status, error.response.data);
    } else {
      console.log('网络错误:', error.message);
    }
  }
}

checkAuthStatus();