package com.attendence.api_server.Asset;

import com.attendence.api_server.member.Member;
import com.attendence.api_server.member.Role;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Collections;
import java.util.Enumeration;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class Asset_Service {

    private final Asset_Repository assetRepository;

    private final String BASE_FOLDER_PATH="D:\\study_source\\KLTN\\Result\\API_server\\api_server\\api_server\\assets\\";

    public Asset uploadAsset(MultipartFile file, Member requester) throws IOException
    {
        if(!Member.hasAdminPrivileges(requester))
            throw new IllegalStateException("Unauthorized for this service");
        String filepath=BASE_FOLDER_PATH+file.getOriginalFilename();
        Asset asset=assetRepository.save(
                Asset.builder().
                name(file.getOriginalFilename()).
                asset_type(file.getContentType()).
                asset_local_path(filepath).
                asset_link(InetAddress.getLocalHost().getHostAddress()+":8080/assets/"+file.getOriginalFilename()).build());
        file.transferTo(new File(filepath));
        return asset;
    }
    @Transactional
    public void deleteAsset_byName(String assetName,Member requester) throws Exception
    {
        if(!Member.hasAdminPrivileges(requester))
            throw new IllegalStateException("Unauthorized for this service");
        Optional<Asset>deleteAsset=assetRepository.findByName(assetName);
        if(deleteAsset.isPresent())
        {
            Files.delete(Path.of(deleteAsset.get().getAsset_local_path()));
            assetRepository.delete(deleteAsset.get());
        }
        else
            throw new IllegalStateException("No asset named "+assetName+" !");
    }

}
