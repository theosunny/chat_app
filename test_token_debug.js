// Token调试测试脚本
const axios = require('axios');

const BASE_URL = 'http://localhost:8080/api';

// 从日志中提取的token
const token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjo0LCJpc3MiOiJjaGF0X2FwcF9iYWNrZW5kIiwiZXhwIjoxNzU0NTAxNzUyLCJpYXQiOjE3NTM4OTY5NTJ9.-m9f1fcJ0k4Ov_UqsOloL2Uos3312d3FoqV3bHqXDpU';

async function testTokenValidity() {
  console.log('=== 测试Token有效性 ===');
  console.log('Token:', token);
  
  try {
    // 测试用户信息接口
    console.log('\n测试用户信息接口...');
    const profileResponse = await axios.get(`${BASE_URL}/user/profile`, {
      headers: {
        'Authorization': `Bearer ${token}`
      }
    });
    console.log('用户信息请求成功:', profileResponse.status);
    
    // 测试会话列表接口
    console.log('\n测试会话列表接口...');
    const conversationsResponse = await axios.get(`${BASE_URL}/messages/conversations`, {
      headers: {
        'Authorization': `Bearer ${token}`
      }
    });
    console.log('会话列表请求成功:', conversationsResponse.status);
    
  } catch (error) {
    console.error('请求失败:');
    console.error('状态码:', error.response?.status);
    console.error('错误信息:', error.response?.data);
    console.error('请求头:', error.config?.headers);
  }
}

// 解析JWT token
function parseJWT(token) {
  try {
    const parts = token.split('.');
    const payload = JSON.parse(Buffer.from(parts[1], 'base64').toString());
    console.log('\n=== Token解析结果 ===');
    console.log('用户ID:', payload.user_id);
    console.log('发行者:', payload.iss);
    console.log('发行时间:', new Date(payload.iat * 1000));
    console.log('过期时间:', new Date(payload.exp * 1000));
    console.log('当前时间:', new Date());
    console.log('是否过期:', new Date() > new Date(payload.exp * 1000));
  } catch (error) {
    console.error('Token解析失败:', error.message);
  }
}

async function main() {
  parseJWT(token);
  await testTokenValidity();
}

main();