// JWT认证测试脚本
const axios = require('axios');

const BASE_URL = 'http://localhost:8080/api';

// 测试数据
const testPhone = '13800138000';
const testCode = '123456';

let authToken = '';

async function testSendCode() {
  console.log('\n=== 测试发送验证码 ===');
  try {
    const response = await axios.post(`${BASE_URL}/user/send-code`, {
      phone: testPhone
    });
    console.log('发送验证码成功:', response.data);
    return true;
  } catch (error) {
    console.error('发送验证码失败:', error.response?.data || error.message);
    return false;
  }
}

async function testLogin() {
  console.log('\n=== 测试手机号登录 ===');
  try {
    const response = await axios.post(`${BASE_URL}/user/login`, {
      phone: testPhone,
      code: testCode
    });
    console.log('登录成功:', response.data);
    
    if (response.data.success && response.data.data.token) {
      authToken = response.data.data.token;
      console.log('获取到JWT Token:', authToken.substring(0, 50) + '...');
      return true;
    }
    return false;
  } catch (error) {
    console.error('登录失败:', error.response?.data || error.message);
    return false;
  }
}

async function testGetProfile() {
  console.log('\n=== 测试获取用户信息（需要JWT认证）===');
  try {
    const response = await axios.get(`${BASE_URL}/user/profile`, {
      headers: {
        'Authorization': `Bearer ${authToken}`
      }
    });
    console.log('获取用户信息成功:', response.data);
    return true;
  } catch (error) {
    console.error('获取用户信息失败:', error.response?.data || error.message);
    return false;
  }
}

async function testGetBottles() {
  console.log('\n=== 测试获取漂流瓶列表（需要JWT认证）===');
  try {
    const response = await axios.get(`${BASE_URL}/bottles`, {
      headers: {
        'Authorization': `Bearer ${authToken}`
      }
    });
    console.log('获取漂流瓶列表成功:', response.data);
    return true;
  } catch (error) {
    console.error('获取漂流瓶列表失败:', error.response?.data || error.message);
    return false;
  }
}

async function testWithoutAuth() {
  console.log('\n=== 测试无认证访问受保护接口 ===');
  try {
    const response = await axios.get(`${BASE_URL}/user/profile`);
    console.log('意外成功（应该失败）:', response.data);
    return false;
  } catch (error) {
    if (error.response?.status === 401) {
      console.log('正确返回401未授权错误:', error.response.data);
      return true;
    }
    console.error('意外错误:', error.response?.data || error.message);
    return false;
  }
}

async function runTests() {
  console.log('开始JWT认证集成测试...');
  
  const results = {
    sendCode: await testSendCode(),
    login: await testLogin(),
    getProfile: false,
    getBottles: false,
    withoutAuth: await testWithoutAuth()
  };
  
  if (results.login && authToken) {
    results.getProfile = await testGetProfile();
    results.getBottles = await testGetBottles();
  }
  
  console.log('\n=== 测试结果汇总 ===');
  console.log('发送验证码:', results.sendCode ? '✅ 通过' : '❌ 失败');
  console.log('用户登录:', results.login ? '✅ 通过' : '❌ 失败');
  console.log('获取用户信息:', results.getProfile ? '✅ 通过' : '❌ 失败');
  console.log('获取漂流瓶:', results.getBottles ? '✅ 通过' : '❌ 失败');
  console.log('无认证访问保护:', results.withoutAuth ? '✅ 通过' : '❌ 失败');
  
  const passedTests = Object.values(results).filter(Boolean).length;
  const totalTests = Object.keys(results).length;
  
  console.log(`\n总体结果: ${passedTests}/${totalTests} 测试通过`);
  
  if (passedTests === totalTests) {
    console.log('🎉 所有测试通过！JWT认证集成成功！');
  } else {
    console.log('⚠️  部分测试失败，请检查配置。');
  }
}

// 运行测试
runTests().catch(console.error);