package com.attendence.api_server.config;

import org.eclipse.paho.client.mqttv3.MqttConnectOptions;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.integration.annotation.ServiceActivator;
import org.springframework.integration.channel.DirectChannel;
import org.springframework.integration.mqtt.core.DefaultMqttPahoClientFactory;
import org.springframework.integration.mqtt.core.MqttPahoClientFactory;
import org.springframework.integration.mqtt.outbound.MqttPahoMessageHandler;
import org.springframework.messaging.MessageChannel;
import org.springframework.messaging.MessageHandler;

@Configuration
public class MqttBeans {
    public MqttPahoClientFactory mqttPahoClientFactory()
    {
        DefaultMqttPahoClientFactory  factory=new DefaultMqttPahoClientFactory();
        MqttConnectOptions options=new MqttConnectOptions();
        options.setServerURIs(new String[]{"tcp://192.168.120.46:1883"});
        options.setUserName("batman");
        options.setPassword("brucewayne".toCharArray());
        options.setCleanSession(true);
        options.setConnectionTimeout(1);
        factory.setConnectionOptions(options);
        return factory;
    }
    @Bean
    public MessageChannel mqttOutboundChannel()
    {
        return new DirectChannel();
    }

    @Bean
    @ServiceActivator(inputChannel = "mqttOutboundChannel")
    public MessageHandler mqttOutbound()
    {
        try {
            MqttPahoMessageHandler outboundHandler = new MqttPahoMessageHandler("ClassInformer", mqttPahoClientFactory());
            outboundHandler.setAsync(true);
            outboundHandler.setDefaultTopic("/mqtt/class");
            return outboundHandler;
        }
        catch (Exception e)
        {
            return null;
        }
    }
}
